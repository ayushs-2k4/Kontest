//
//  LeetCodeGraphQLAPIDTO.swift
//  Kontest
//
//  Created by Ayush Singhal on 04/09/23.
//

import Foundation
import LeetCodeSchema

// MARK: - LeetCodeGraphQLAPIDTO

struct LeetCodeGraphQLAPIDTO: Codable {
    let languageProblemCount: [LanguageProblemCount?]?
    let contestBadge: ContestBadge?
    let username: String?
    let githubUrl: String?
    let twitterUrl: String?
    let linkedinUrl: String?
    let profile: UserProfile?
}

struct LanguageProblemCount: Codable {
    let languageName: String?
    let problemsSolved: Int?
}

struct ContestBadge: Codable {
    let name: String?
    let expired: Bool?
    let hoverText: String?
    let icon: String?
}

struct UserProfile: Codable {
    let ranking: Int?
    let userAvatar: String?
    let realName: String?
    let aboutMe: String?
    let school: String?
    let websites: [String?]?
    let countryName: String?
    let company: String?
    let jobTitle: String?
    let skillTags: [String?]?
    let postViewCount: Int?
    let postViewCountDiff: Int?
    let reputation: Int?
    let reputationDiff: Int?
    let solutionCount: Int?
    let solutionCountDiff: Int?
    let categoryDiscussCount: Int?
    let categoryDiscussCountDiff: Int?
}

extension UserProfile {
    static func from(graphQLUserProfile: UserPublicProfileQuery.Data.MatchedUser.Profile?) -> UserProfile? {
        guard let profileData = graphQLUserProfile else {
            return nil
        }

        return UserProfile(
            ranking: profileData.ranking,
            userAvatar: profileData.userAvatar,
            realName: profileData.realName,
            aboutMe: profileData.aboutMe,
            school: profileData.school,
            websites: profileData.websites ?? [],
            countryName: profileData.countryName,
            company: profileData.company,
            jobTitle: profileData.jobTitle,
            skillTags: profileData.skillTags ?? [],
            postViewCount: profileData.postViewCount,
            postViewCountDiff: profileData.postViewCountDiff,
            reputation: profileData.reputation,
            reputationDiff: profileData.reputationDiff,
            solutionCount: profileData.solutionCount,
            solutionCountDiff: profileData.solutionCountDiff,
            categoryDiscussCount: profileData.categoryDiscussCount,
            categoryDiscussCountDiff: profileData.categoryDiscussCountDiff
        )
    }
}

extension ContestBadge {
    static func from(contestBadge: UserPublicProfileQuery.Data.MatchedUser.ContestBadge?) -> ContestBadge? {
        guard let contestBadge = contestBadge else {
            return nil
        }

        return ContestBadge(name: contestBadge.name, expired: contestBadge.expired, hoverText: contestBadge.hoverText, icon: contestBadge.icon)
    }
}

extension LanguageProblemCount {
    static func from(languageProblemCount: UserPublicProfileQuery.Data.MatchedUser.LanguageProblemCount?) -> LanguageProblemCount? {
        guard let languageProblemCount = languageProblemCount else {
            return nil
        }

        return LanguageProblemCount(languageName: languageProblemCount.languageName, problemsSolved: languageProblemCount.problemsSolved)
    }

    static func from(languageProblemCounts: [UserPublicProfileQuery.Data.MatchedUser.LanguageProblemCount?]?) -> [LanguageProblemCount?]? {
        guard let languageProblemCounts else { return nil }

        return languageProblemCounts.map { languageProblemCount in
            from(languageProblemCount: languageProblemCount)
        }
    }
}
