//
//  LeetCodeGraphQLViewModel.swift
//  Kontest
//
//  Created by Ayush Singhal on 04/09/23.
//

import Foundation
import OSLog

@Observable
class LeetCodeGraphQLViewModel {
    private let logger = Logger(subsystem: "com.ayushsinghal.Kontest", category: "FilterWebsitesViewModel")

    let repository = LeetCodeAPIGraphQLRepository()

    var leetCodeUserProfileGraphQLAPIModel: LeetCodeUserProfileGraphQLAPIModel?
    var userContestRanking: LeetCodeUserRankingGraphQLAPIModel?
    var userContestRankingHistory: [LeetCodeUserRankingHistoryGraphQLAPIModel?]?
    var error: Error?

    var isLoading: Bool = false
    var isFetchingUserData: Bool = false
    var isFetchingUserRankings: Bool = false

    init(username: String) {
        self.isFetchingUserData = true
        self.isFetchingUserRankings = true
        self.isLoading = true
        fetchUserData(username: username)
        fetchUserRankings(username: username)
    }

    func fetchUserData(username: String) {
        print("Ran")
        repository.getUserData(username: username) { [weak self] leetCodeUserProfileGraphQLAPIDTO, error in
            if error != nil {
                self?.logger.error("\(error)")
                self?.error = error
            } else {
                if let leetCodeUserProfileGraphQLAPIDTO {
                    // Handle the data here when the GraphQL query succeeds.
                    self?.logger.info("-------\("\(leetCodeUserProfileGraphQLAPIDTO)")----------")

                    self?.leetCodeUserProfileGraphQLAPIModel = LeetCodeUserProfileGraphQLAPIModel.from(leetCodeUserProfileGraphQLAPIDTO: leetCodeUserProfileGraphQLAPIDTO)
                    self?.error = nil
                } else {
                    // Handle the case when the GraphQL query fails or returns nil data.
                    self?.logger.error("Failed to fetchUserData.")
                    self?.error = URLError(.badURL)
                }
            }

            self?.isFetchingUserData = false
            self?.isLoading = (self?.isFetchingUserData ?? false) || (self?.isFetchingUserRankings ?? false)
        }
    }

    func fetchUserRankings(username: String) {
        repository.getUserRankingInfo(username: username) { [weak self] leetCodeUserRankingsGraphQLAPIDTO, error in
            if error != nil {
                self?.logger.error("\(error)")
                self?.error = error
            } else {
                if let leetCodeUserRankingsGraphQLAPIDTO, let userContestRanking = LeetCodeUserRankingGraphQLAPIModel.from(leetCodeUserRankingGraphQLAPIDTO: leetCodeUserRankingsGraphQLAPIDTO.leetCodeUserRankingGraphQLAPIDTO), let userContestRankingHistory = LeetCodeUserRankingHistoryGraphQLAPIModel.from(leetCodeUserRankingHistoryGraphQLAPIDTOs: leetCodeUserRankingsGraphQLAPIDTO.leetCodeUserRankingHistoryGraphQLAPIDTO) {
                    self?.userContestRanking = userContestRanking

                    self?.userContestRankingHistory = userContestRankingHistory

                    self?.error = nil
                } else {
                    self?.logger.error("Failed to fetchUserRankings.")
                    self?.error = URLError(.badURL)
                }
            }

            self?.isFetchingUserRankings = false
            self?.isLoading = (self?.isFetchingUserData ?? false) || (self?.isFetchingUserRankings ?? false)
        }
    }
}
