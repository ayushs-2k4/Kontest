//
//  DownloadData.swift
//  Kontest
//
//  Created by Ayush Singhal on 12/08/23.
//

@preconcurrency import Apollo
import Combine
import Foundation

final class DownloadDataWithApollo: Sendable {
    static let shared = DownloadDataWithApollo()

    let apollo = ApolloClient(url: URL(string: "https://leetcode.com/graphql?query=")!)

    private init() {}
}

final class DownloadDataWithApollo2: Sendable {
    let apollo: ApolloClient
    
    // Store the last created instance for reuse
    private static var instanceCache: [URL: DownloadDataWithApollo2] = [:]
    
    private init(url: URL) {
        self.apollo = ApolloClient(url: url)
    }
    
    // Factory method to return the cached instance if available, or create a new one
    static func getInstance(url: URL) -> DownloadDataWithApollo2 {
        if let cachedInstance = instanceCache[url] {
            return cachedInstance
        } else {
            let newInstance = DownloadDataWithApollo2(url: url)
            instanceCache[url] = newInstance
            return newInstance
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
