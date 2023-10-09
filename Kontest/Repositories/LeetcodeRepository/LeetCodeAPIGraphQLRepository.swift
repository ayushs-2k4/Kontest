//
//  LeetAPIGraphQLRepository.swift
//  Kontest
//
//  Created by Ayush Singhal on 04/09/23.
//

import Foundation
import LeetCodeSchema
import OSLog

class LeetCodeAPIGraphQLRepository: LeetCodeGraphQLAPIFetcher {
    private let logger = Logger(subsystem: "com.ayushsinghal.Kontest", category: "LeetCodeAPIGraphQLRepository")
    
    internal func getUserData(username: String, completion: @escaping (LeetCodeUserProfileGraphQLAPIDTO?, Error?) -> Void) {
        let query = UserPublicProfileQuery(username: username)
        
        DownloadDataWithApollo.shared.apollo.fetch(query: query) { [weak self] result in
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
                        linkedinUrl: p.linkedinUrl,
                        profile: UserProfileDTO.from(graphQLUserProfile: p.profile),
                        problemsSolvedBeatsStats: ProblemSolvedBeatsStatsDTO.from(problemsSolvedBeatsStats: p.problemsSolvedBeatsStats),
                        submitStatsGlobal: SubmitStatsGlobalDTO.from(submitStatsGlobal: p.submitStatsGlobal)
                    )
                    
                    completion(leetCodeGraphQLAPIDTO, nil)
                } else {
                    completion(nil, AppError(title: "Data not found", description: "Data not found in  LeetCodeAPIGraphQLRepository - getUserData"))
                }
            case .failure(let error):
                self?.logger.error("Error in LeetCodeAPIGraphQLRepository - getUserData: \(error)")
                completion(nil, error)
            }
        }
    }
    
    internal func getUserRankingInfo(username: String, completion: @escaping (LeetCodeUserRankingsGraphQLAPIDTO?, Error?) -> Void) {
        let query = UserContestRankingInfoQuery(username: username)
        
        DownloadDataWithApollo.shared.apollo.fetch(query: query) { [weak self] result in
            switch result {
            case .success(let value):
                let userContestRanking = value.data?.userContestRanking
                let userContestRankingHistory = value.data?.userContestRankingHistory
                
                let leetCodeUserRankingsGraphQLAPIDTO = LeetCodeUserRankingsGraphQLAPIDTO(leetCodeUserRankingGraphQLAPIDTO: LeetCodeUserRankingGraphQLAPIDTO.from(userContestRanking: userContestRanking), leetCodeUserRankingHistoryGraphQLAPIDTO: LeetCodeUserRankingHistoryGraphQLAPIDTO.from(leetCodeUserRankingHistoryGraphQLAPIDTOs: userContestRankingHistory))
                
                completion(leetCodeUserRankingsGraphQLAPIDTO, nil)
                
            case .failure(let error):
                self?.logger.error("Error in LeetCodeAPIGraphQLRepository - getUserRankingInfo: \(error)")
                completion(nil, error)
            }
        }
    }
    
    func getUserData(username: String) async throws -> LeetCodeUserProfileGraphQLAPIDTO {
        return try await withCheckedThrowingContinuation { continuation in
            getUserData(username: username) { leetCodeUserProfileGraphQLAPIDTO, error in
                if let error {
                    continuation.resume(throwing: error)
                } else if let leetCodeUserProfileGraphQLAPIDTO {
                    continuation.resume(returning: leetCodeUserProfileGraphQLAPIDTO)
                } else {
                    continuation.resume(throwing: URLError(.badURL))
                }
            }
        }
    }
    
    func getUserRankingInfo(username: String) async throws -> LeetCodeUserRankingsGraphQLAPIDTO {
        return try await withCheckedThrowingContinuation { continuation in
            getUserRankingInfo(username: username) { leetCodeUserRankingsGraphQLAPIDTO, error in
                if let error {
                    continuation.resume(throwing: error)
                } else if let leetCodeUserRankingsGraphQLAPIDTO {
                    continuation.resume(returning: leetCodeUserRankingsGraphQLAPIDTO)
                } else {
                    continuation.resume(throwing: URLError(.badURL))
                }
            }
        }
    }
}
