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

func downloadDataWithAsyncAwait(url: URL) async throws -> Data {
    let (data, response) = try await URLSession.shared.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse,
          (200 ..< 300).contains(httpResponse.statusCode)
    else {
        throw URLError(.badServerResponse)
    }

    return data
}
