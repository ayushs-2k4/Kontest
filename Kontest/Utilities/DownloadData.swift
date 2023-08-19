//
//  DownloadData.swift
//  Kontest
//
//  Created by Ayush Singhal on 12/08/23.
//

import Combine
import Foundation


func downloadDataWithAsyncAwait(url: URL) async throws -> Data {
    let (data, response) = try await URLSession.shared.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse,
          (200 ..< 300).contains(httpResponse.statusCode)
    else {
        throw URLError(.badServerResponse)
    }

    return data
}
