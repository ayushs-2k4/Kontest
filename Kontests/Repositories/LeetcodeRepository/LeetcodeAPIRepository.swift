//
//  LeetcodeAPIRepository.swift
//  Kontests
//
//  Created by Ayush Singhal on 16/08/23.
//

import Foundation

class LeetcodeAPIRepository: LeetcodeFetcher {
    func getUserData(username: String) async throws -> LeetcodeAPIDTO {
        guard let url = URL(string: "https://leetcode-stats-api.herokuapp.com/\(username)") else {
            print("Error in making leetcode url")
            throw URLError(.badURL)
        }

        do {
            let data = try await downloadDataWithAsyncAwait(url: url)
            let fetchedLeetcodeProfile = try JSONDecoder().decode(LeetcodeAPIDTO.self, from: data)

            return fetchedLeetcodeProfile
        } catch {
            print("error in downloading Leetcode profile async await: \(error)")
            throw error
        }
    }
}
