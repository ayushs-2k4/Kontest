//
//  LeetCodeGraphQLViewModel.swift
//  Kontest
//
//  Created by Ayush Singhal on 04/09/23.
//

import Foundation

@Observable
class LeetCodeGraphQLViewModel {
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
        repository.getUserData(username: username) { [weak self] leetCodeUserProfileGraphQLAPIDTO in
            if let leetCodeUserProfileGraphQLAPIDTO {
                // Handle the data here when the GraphQL query succeeds.
                print("Received data: \(leetCodeUserProfileGraphQLAPIDTO)")
                self?.leetCodeUserProfileGraphQLAPIModel = LeetCodeUserProfileGraphQLAPIModel.from(leetCodeUserProfileGraphQLAPIDTO: leetCodeUserProfileGraphQLAPIDTO)
                self?.error = nil
            } else {
                // Handle the case when the GraphQL query fails or returns nil data.
                print("Failed to fetchUserData.")
                self?.error = URLError(.badURL)
            }
            self?.isFetchingUserData = false
            self?.isLoading = (self?.isFetchingUserData ?? false) || (self?.isFetchingUserRankings ?? false)
        }
    }

    func fetchUserRankings(username: String) {
        repository.getUserRankingInfo(username: username) { [weak self] leetCodeUserRankingsGraphQLAPIDTO in
            if let leetCodeUserRankingsGraphQLAPIDTO, let userContestRanking = LeetCodeUserRankingGraphQLAPIModel.from(leetCodeUserRankingGraphQLAPIDTO: leetCodeUserRankingsGraphQLAPIDTO.leetCodeUserRankingGraphQLAPIDTO), let userContestRankingHistory = LeetCodeUserRankingHistoryGraphQLAPIModel.from(leetCodeUserRankingHistoryGraphQLAPIDTOs: leetCodeUserRankingsGraphQLAPIDTO.leetCodeUserRankingHistoryGraphQLAPIDTO) {
                self?.userContestRanking = userContestRanking

                self?.userContestRankingHistory = userContestRankingHistory

                self?.error = nil
            } else {
                print("Failed to fetchUserRankings.")
                self?.error = URLError(.badURL)
            }
            self?.isFetchingUserRankings = false
            self?.isLoading = (self?.isFetchingUserData ?? false) || (self?.isFetchingUserRankings ?? false)
        }
    }
}
