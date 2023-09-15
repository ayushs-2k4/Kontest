//
//  CodeChefAPIRepository.swift
//  Kontest
//
//  Created by Ayush Singhal on 27/08/23.
//

import Foundation
import OSLog

class CodeChefAPIRepository: CodeChefFetcher {
    private let logger = Logger(subsystem: "com.ayushsinghal.Kontest", category: "CodeChefAPIRepository")
    
    func getUserData(username: String) async throws -> CodeChefAPIDTO {
        guard let url = URL(string: "https://codechef-api.vercel.app/\(username)") else {
            logger.error("Error in making CodeChef url")
            throw URLError(.badURL)
        }

        do {
            let data = try await downloadDataWithAsyncAwait(url: url)
            let fetchedCodeChefProfile = try JSONDecoder().decode(CodeChefAPIDTO.self, from: data)

            return fetchedCodeChefProfile
        } catch {
            logger.error("error in downloading CodeChef profile async await: \(error)")
            throw error
        }
    }
}
