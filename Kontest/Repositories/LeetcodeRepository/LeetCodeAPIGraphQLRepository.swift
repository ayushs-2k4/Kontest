//
//  LeetAPIGraphQLRepository.swift
//  Kontest
//
//  Created by Ayush Singhal on 04/09/23.
//

import Foundation
import LeetCodeSchema

class LeetCodeAPIGraphQLRepository: LeetCodeGraphQLAPIFetcher {
    func getUserData(username: String, completion: @escaping (LeetCodeUserProfileGraphQLAPIDTO?, Error?) -> Void) {
        let query = UserPublicProfileQuery(username: username)

        DownloadData.shared.apollo.fetch(query: query) { result in
            switch result {
            case .success(let value):
                let p = value.data?.matchedUser

                if let p {
                    let leetCodeGraphQLAPIDTO = LeetCodeUserProfileGraphQLAPIDTO(
                        languageProblemCount: LanguageProblemCountDTO.from(languageProblemCounts: p.languageProblemCount),
                        contestBadge: ContestBadgeDTO.from(contestBadge: p.contestBadge),
                        username: p.username,
                        githubUrl: p.githubUrl,
                        twitterUrl: p.twitterUrl,
                        linkedinUrl: p.linkedinUrl!,
                        profile: UserProfileDTO.from(graphQLUserProfile: p.profile),
                        problemsSolvedBeatsStats: ProblemSolvedBeatsStatsDTO.from(problemsSolvedBeatsStats: p.problemsSolvedBeatsStats),
                        submitStatsGlobal: SubmitStatsGlobalDTO.from(submitStatsGlobal: p.submitStatsGlobal)
                    )

                    completion(leetCodeGraphQLAPIDTO, nil)
                } else {
                    completion(nil, AppError(description: "Data not found in  LeetCodeAPIGraphQLRepository - getUserData"))
                }
            case .failure(let error):
                print("Error in LeetCodeAPIGraphQLRepository - getUserData: \(error)")
                completion(nil, error)
            }
        }
    }

    func getUserRankingInfo(username: String, completion: @escaping (LeetCodeUserRankingsGraphQLAPIDTO?, Error?) -> Void) {
        let query = UserContestRankingInfoQuery(username: username)

        DownloadData.shared.apollo.fetch(query: query) { result in
            switch result {
            case .success(let value):
                let userContestRanking = value.data?.userContestRanking
                let userContestRankingHistory = value.data?.userContestRankingHistory

                let leetCodeUserRankingsGraphQLAPIDTO = LeetCodeUserRankingsGraphQLAPIDTO(leetCodeUserRankingGraphQLAPIDTO: LeetCodeUserRankingGraphQLAPIDTO.from(userContestRanking: userContestRanking), leetCodeUserRankingHistoryGraphQLAPIDTO: LeetCodeUserRankingHistoryGraphQLAPIDTO.from(leetCodeUserRankingHistoryGraphQLAPIDTOs: userContestRankingHistory))

                completion(leetCodeUserRankingsGraphQLAPIDTO, nil)

            case .failure(let error):
                print("Error in LeetCodeAPIGraphQLRepository - getUserRankingInfo: \(error)")
                completion(nil, error)
            }
        }
    }
}
