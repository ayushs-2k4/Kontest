//
//  LeetAPIGraphQLRepository.swift
//  Kontest
//
//  Created by Ayush Singhal on 04/09/23.
//

import Foundation
import LeetCodeSchema

class LeetCodeAPIGraphQLRepository: LeetCodeGraphQLAPIFetcher {
    func getUserData(username: String, completion: @escaping (LeetCodeUserProfileGraphQLAPIDTO?) -> Void) {
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
                        profile: UserProfileDTO.from(graphQLUserProfile: p.profile)
                    )

                    completion(leetCodeGraphQLAPIDTO)
                } else {
                    completion(nil)
                }
            case .failure(let error):
                print("Error in LeetAPIGraphQLRepository: \(error)")
                completion(nil)
            }
        }
    }
}

