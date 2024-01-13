//
//  CodeChefViewModel.swift
//  Kontest
//
//  Created by Ayush Singhal on 27/08/23.
//

import Foundation
import OSLog

@Observable
class CodeChefViewModel {
    private let logger = Logger(subsystem: "com.ayushsinghal.Kontest", category: "CodeChefViewModel")

    let codeChefAPIRepository = CodeChefAPIRepository()
    let codeChefScrapingAPIRepository = CodeChefScrapingAPIRepository()

    let username: String
    var codeChefProfile: CodeChefAPIModel?

    var attendedKontests: [CodeChefScrapingContestModel] = []

    var isLoading = false

    var error: Error?

    init(username: String) {
        self.isLoading = true
        self.username = username

        if !username.isEmpty {
            Task {
                await self.getCodeChefProfile(username: username)
                await self.getCodeChefRatings(username: username)

                self.isLoading = false
            }
        } else {
            self.isLoading = false
        }
    }

    private func getCodeChefProfile(username: String) async {
        do {
            let fetchedCodeChefProfile = try await codeChefAPIRepository.getUserData(username: username)

            codeChefProfile = CodeChefAPIModel.from(codeChefAPIDTO: fetchedCodeChefProfile)
        } catch {
            self.error = error
            logger.error("error in fetching CodeChef Profile: \(error)")
        }
    }

    private func getCodeChefRatings(username: String) async {
        do {
            let fetchedCodeChefRatings = try await codeChefScrapingAPIRepository.getUserKontests(username: username)

            attendedKontests.append(contentsOf:
                fetchedCodeChefRatings.map {
                    codeChefScrapingContestDTO in
                    CodeChefScrapingContestModel.from(dto: codeChefScrapingContestDTO)
                })
        } catch {
            self.error = error
            logger.error("error in fetching CodeChef Ratings: \(error)")
        }
    }
}
