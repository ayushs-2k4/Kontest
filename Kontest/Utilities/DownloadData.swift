//
//  DownloadData.swift
//  Kontest
//
//  Created by Ayush Singhal on 12/08/23.
//

@preconcurrency import Apollo
import Combine
import Foundation

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

final class DownloadDataWithApollo: Sendable {
    static let shared = DownloadDataWithApollo()

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
        let store = ApolloStore()

        // Create a custom RequestChainNetworkTransport to add headers to each request
        let networkTransport = RequestChainNetworkTransport(interceptorProvider: DefaultInterceptorProvider(store: store),
                                                            endpointURL: url,
                                                            additionalHeaders: customHeaders)

        let apolloClient = ApolloClient(networkTransport: networkTransport, store: store)
        return DownloadDataWithApollo2(apollo: apolloClient)
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
