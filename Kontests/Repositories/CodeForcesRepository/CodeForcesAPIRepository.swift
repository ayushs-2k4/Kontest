//
//  CodeForcesAPIRepository.swift
//  Kontests
//
//  Created by Ayush Singhal on 16/08/23.
//

import Foundation

class CodeForcesAPIRepository: CodeForcesFetcher {
    func getUserData(username: String) async throws -> CodeForcesAPIDTO {
        guard let url = URL(string: "https://codeforces.com/api/user.rating?handle=\(username)") else {
            print("Error in making CodeForces url")
            throw URLError(.badURL)
        }

        do {
            let data = try await downloadDataWithAsyncAwait(url: url)
            let fetchedCodeForcesProfile = try JSONDecoder().decode(CodeForcesAPIDTO.self, from: data)

            return fetchedCodeForcesProfile
        } catch {
            print("error in downloading CodeForces profile async await: \(error)")
            throw error
        }
    }
}
