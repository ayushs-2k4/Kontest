//
//  CodeForcesAPIRepository.swift
//  Kontest
//
//  Created by Ayush Singhal on 16/08/23.
//

import Foundation

class CodeForcesAPIRepository: CodeForcesFetcher {
    func getUserRating(username: String) async throws -> CodeForcesUserRatingAPIDTO {
        guard let url = URL(string: "https://codeforces.com/api/user.rating?handle=\(username)") else {
            print("Error in making CodeForces ratings url")
            throw URLError(.badURL)
        }

        do {
            let data = try await downloadDataWithAsyncAwait(url: url)
            let fetchedCodeForcesRatings = try JSONDecoder().decode(CodeForcesUserRatingAPIDTO.self, from: data)

            return fetchedCodeForcesRatings
        } catch {
            print("error in downloading CodeForces ratings async await: \(error)")
            throw error
        }
    }

    func getUserInfo(username: String) async throws -> CodeForcesUserInfoAPIDTO {
        guard let url = URL(string: "https://codeforces.com/api/user.info?handles=\(username)") else {
            print("Error in making CodeForces profile url")
            throw URLError(.badURL)
        }

        do {
            let data = try await downloadDataWithAsyncAwait(url: url)
            let fetchedCodeForcesProfile = try JSONDecoder().decode(CodeForcesUserInfoAPIDTO.self, from: data)

            return fetchedCodeForcesProfile
        } catch {
            print("error in downloading CodeForces User Info async await: \(error)")
            throw error
        }
    }
}
