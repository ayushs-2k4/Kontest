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

    var isLoading: Bool = false

    init(username: String) {
        isLoading = true
        fetchUserData(username: username)
        fetchUserRankings(username: username)
    }

    func fetchUserData(username: String) {
        repository.getUserData(username: username) { [weak self] leetCodeUserProfileGraphQLAPIDTO in
            if let leetCodeUserProfileGraphQLAPIDTO {
                // Handle the data here when the GraphQL query succeeds.
                print("Received data: \(leetCodeUserProfileGraphQLAPIDTO)")
                self?.leetCodeUserProfileGraphQLAPIModel = LeetCodeUserProfileGraphQLAPIModel.from(leetCodeUserProfileGraphQLAPIDTO: leetCodeUserProfileGraphQLAPIDTO)
                self?.isLoading = false
            } else {
                // Handle the case when the GraphQL query fails or returns nil data.
                print("Failed to fetchUserData.")
            }
        }
    }

    func fetchUserRankings(username: String) {
        repository.getUserRankingInfo(username: username) { [weak self] leetCodeUserRankingsGraphQLAPIDTO in
            if let leetCodeUserRankingsGraphQLAPIDTO {
                self?.userContestRanking = LeetCodeUserRankingGraphQLAPIModel.from(leetCodeUserRankingGraphQLAPIDTO: leetCodeUserRankingsGraphQLAPIDTO.leetCodeUserRankingGraphQLAPIDTO)

                self?.userContestRankingHistory = LeetCodeUserRankingHistoryGraphQLAPIModel.from(leetCodeUserRankingHistoryGraphQLAPIDTOs: leetCodeUserRankingsGraphQLAPIDTO.leetCodeUserRankingHistoryGraphQLAPIDTO)
            } else {
                print("Failed to fetchUserRankings.")
            }
        }
    }
}
