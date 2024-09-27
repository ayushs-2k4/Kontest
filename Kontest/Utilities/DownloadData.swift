//
//  DownloadData.swift
//  Kontest
//
//  Created by Ayush Singhal on 12/08/23.
//

@preconcurrency import Apollo
import ApolloAPI
import Combine
import Foundation
import OSLog

struct ApolloCacheKey: Hashable {
    let url: URL
    let headers: [String: String]

    // Conformance to Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
        headers.forEach { hasher.combine($0.key); hasher.combine($0.value) }
    }

    // Conformance to Equatable
    static func ==(lhs: ApolloCacheKey, rhs: ApolloCacheKey) -> Bool {
        return lhs.url == rhs.url && lhs.headers == rhs.headers
    }
}

final class DownloadLeetcodeDataWithApollo: Sendable {
    static let shared = DownloadLeetcodeDataWithApollo()

    let apollo = ApolloClient(url: URL(string: "https://leetcode.com/graphql?query=")!)

    private init() {}
}

// A class to manage Apollo client instances with custom headers
final class DownloadDataWithApollo2: Sendable {
    let apollo: ApolloClient

    // Initialize with the ApolloClient
    init(apollo: ApolloClient) {
        self.apollo = apollo
    }

    // Create an instance with custom headers
    static func createWithCustomHeaders(url: URL, customHeaders: [String: String]) -> DownloadDataWithApollo2 {
        let store = ApolloStore(cache: InMemoryNormalizedCache())
        let client = URLSessionClient()

        let interceptorProvider = NetworkInterceptorProvider(store: store, client: client)

        // Create a custom RequestChainNetworkTransport to add headers to each request
        let networkTransport = RequestChainNetworkTransport(interceptorProvider: interceptorProvider,
                                                            endpointURL: url,
                                                            additionalHeaders: customHeaders,
                                                            autoPersistQueries: true,
                                                            useGETForQueries: true,
                                                            useGETForPersistedQueryRetry: true
        )

        let apolloClient = ApolloClient(networkTransport: networkTransport, store: store)
        return DownloadDataWithApollo2(apollo: apolloClient)
    }
}

struct NetworkInterceptorProvider: InterceptorProvider {
    // These properties will remain the same throughout the life of the `InterceptorProvider`, even though they
    // will be handed to different interceptors.
    private let store: ApolloStore
    private let client: URLSessionClient

    init(store: ApolloStore, client: URLSessionClient) {
        self.store = store
        self.client = client
    }

    func interceptors<Operation>(for operation: Operation) -> [any Apollo.ApolloInterceptor] where Operation: ApolloAPI.GraphQLOperation {
        return [
            MaxRetryInterceptor(),
            CacheReadInterceptor(store: self.store),
            NetworkFetchInterceptor(client: self.client),
            ResponseCodeInterceptor(),
            JSONResponseParsingInterceptor(),
            AutomaticPersistedQueryInterceptor(),
            CacheWriteInterceptor(store: self.store),
            ApolloLoggingInterceptor()
        ]
    }
}

class ApolloLoggingInterceptor: ApolloInterceptor {
    private let logger = Logger(subsystem: "com.ayushsinghal.Kontest", category: "ApolloLoggingInterceptor")

    var id: String = ""

    func interceptAsync<Operation>(
        chain: any Apollo.RequestChain,
        request: Apollo.HTTPRequest<Operation>,
        response: Apollo.HTTPResponse<Operation>?,
        completion: @escaping (Result<Apollo.GraphQLResult<Operation.Data>, any Error>) -> Void
    ) where Operation: ApolloAPI.GraphQLOperation {
        // Log the request details
        logger.info("Request ID: \(self.id)")
        logger.info("Request: \("\(request)")")

        // Check if a persisted query is being used
        logger.info("operation: \("\(request.operation)")")
        
        chain.proceedAsync(request: request, response: response, interceptor: self, completion: completion)
    }
}

// Actor to manage cache of DownloadDataWithApollo2 instances
actor DownloadDataWithApollo2Cache {
    private var instanceCache: [ApolloCacheKey: DownloadDataWithApollo2] = [:]

    // Get an instance if available in cache
    func getInstance(for key: ApolloCacheKey) -> DownloadDataWithApollo2? {
        return instanceCache[key]
    }

    // Create a new instance and add to cache
    func createInstance(for key: ApolloCacheKey) -> DownloadDataWithApollo2 {
        let newInstance = DownloadDataWithApollo2.createWithCustomHeaders(url: key.url, customHeaders: key.headers)
        instanceCache[key] = newInstance
        return newInstance
    }
}

// Factory to manage Apollo instances
enum ApolloFactory {
    private static let cache = DownloadDataWithApollo2Cache()

    // Static method to get or create an instance asynchronously
    static func getInstance(url: URL, customHeaders: [String: String] = [:]) async -> DownloadDataWithApollo2 {
        let cacheKey = ApolloCacheKey(url: url, headers: customHeaders)

        // Check if the instance is already in the cache
        if let cachedInstance = await cache.getInstance(for: cacheKey) {
            return cachedInstance
        } else {
            // Create a new instance if not in cache
            return await cache.createInstance(for: cacheKey)
        }
    }
}

func downloadDataWithAsyncAwait(url: URL) async throws -> Data {
    let (data, response) = try await URLSession.shared.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse,
          (200 ..< 300).contains(httpResponse.statusCode)
    else {
        throw URLError(.badServerResponse)
    }

    return data
}
