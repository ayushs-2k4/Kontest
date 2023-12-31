//
//  LeetCodeUserProfileGraphQLAPIModel.swift
//  Kontest
//
//  Created by Ayush Singhal on 04/09/23.
//

import Foundation

// MARK: - LeetCodeUserProfileGraphQLAPIModel

struct LeetCodeUserProfileGraphQLAPIModel: Codable {
    let languageProblemCountModel: [LanguageProblemCountModel?]?
    let contestBadgeModel: ContestBadgeModel?
    let username: String?
    let githubUrl: String?
    let twitterUrl: String?
    let linkedinUrl: String?
    let profileModel: UserProfileModel?
    let problemsSolvedBeatsStats: [ProblemSolvedBeatsStatsModel?]?
    let submitStatsGlobal: SubmitStatsGlobalModel?
}

struct LanguageProblemCountModel: Codable {
    let languageName: String?
    let problemsSolved: Int?
}

struct ContestBadgeModel: Codable {
    let name: String?
    let expired: Bool?
    let hoverText: String?
    let icon: String?
}

struct UserProfileModel: Codable {
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

struct ProblemSolvedBeatsStatsModel: Codable, Hashable {
    let difficulty: String?
    let percentage: Double?
}

struct SubmitStatsGlobalModel: Codable, Hashable, Equatable {
    let acSubmissionNums: [ACSubmissionNumModel?]?
}

struct ACSubmissionNumModel: Codable, Hashable, Equatable {
    let difficulty: String?
    let count: Int?
}

extension LeetCodeUserProfileGraphQLAPIModel {
    static func from(leetCodeUserProfileGraphQLAPIDTO: LeetCodeUserProfileGraphQLAPIDTO) -> LeetCodeUserProfileGraphQLAPIModel {
        return LeetCodeUserProfileGraphQLAPIModel(languageProblemCountModel: LanguageProblemCountModel.from(languageProblemCountDTOs: leetCodeUserProfileGraphQLAPIDTO.languageProblemCount), contestBadgeModel: ContestBadgeModel.from(contestBadgeDTO: leetCodeUserProfileGraphQLAPIDTO.contestBadge), username: leetCodeUserProfileGraphQLAPIDTO.username, githubUrl: leetCodeUserProfileGraphQLAPIDTO.githubUrl, twitterUrl: leetCodeUserProfileGraphQLAPIDTO.twitterUrl, linkedinUrl: leetCodeUserProfileGraphQLAPIDTO.linkedinUrl, profileModel: UserProfileModel.from(userProfileDTO: leetCodeUserProfileGraphQLAPIDTO.profile),
                                                  problemsSolvedBeatsStats: ProblemSolvedBeatsStatsModel.from(problemsSolvedBeatsStatsDTO: leetCodeUserProfileGraphQLAPIDTO.problemsSolvedBeatsStats),
                                                  submitStatsGlobal: SubmitStatsGlobalModel.from(submitStatsGlobalDTO: leetCodeUserProfileGraphQLAPIDTO.submitStatsGlobal))
    }
}

extension LanguageProblemCountModel {
    static func from(languageProblemCountDTO: LanguageProblemCountDTO?) -> LanguageProblemCountModel? {
        return LanguageProblemCountModel(languageName: languageProblemCountDTO?.languageName, problemsSolved: languageProblemCountDTO?.problemsSolved)
    }

    static func from(languageProblemCountDTOs: [LanguageProblemCountDTO?]?) -> [LanguageProblemCountModel?]? {
        return languageProblemCountDTOs?.map { languageProblemCount in
            from(languageProblemCountDTO: languageProblemCount)
        }
    }
}

extension ContestBadgeModel {
    static func from(contestBadgeDTO: ContestBadgeDTO?) -> ContestBadgeModel? {
        return if let contestBadgeDTO {
            ContestBadgeModel(name: contestBadgeDTO.name, expired: contestBadgeDTO.expired, hoverText: contestBadgeDTO.hoverText, icon: contestBadgeDTO.icon)
        } else {
            nil
        }
    }
}

extension UserProfileModel {
    static func from(userProfileDTO: UserProfileDTO?) -> UserProfileModel? {
        return if let userProfileDTO {
            UserProfileModel(ranking: userProfileDTO.ranking, userAvatar: userProfileDTO.userAvatar, realName: userProfileDTO.realName, aboutMe: userProfileDTO.aboutMe, school: userProfileDTO.school, websites: userProfileDTO.websites, countryName: userProfileDTO.countryName, company: userProfileDTO.company, jobTitle: userProfileDTO.jobTitle, skillTags: userProfileDTO.skillTags, postViewCount: userProfileDTO.postViewCount, postViewCountDiff: userProfileDTO.postViewCountDiff, reputation: userProfileDTO.reputation, reputationDiff: userProfileDTO.reputationDiff, solutionCount: userProfileDTO.solutionCount, solutionCountDiff: userProfileDTO.solutionCountDiff, categoryDiscussCount: userProfileDTO.categoryDiscussCount, categoryDiscussCountDiff: userProfileDTO.categoryDiscussCountDiff)
        } else {
            nil
        }
    }
}

extension ACSubmissionNumModel {
    static func from(acSubmissionNumDTO: ACSubmissionNumDTO?) -> ACSubmissionNumModel? {
        guard let acSubmissionNumDTO else { return nil }
        return ACSubmissionNumModel(difficulty: acSubmissionNumDTO.difficulty, count: acSubmissionNumDTO.count)
    }
}

extension SubmitStatsGlobalModel {
    static func from(submitStatsGlobalDTO: SubmitStatsGlobalDTO?) -> SubmitStatsGlobalModel? {
        guard let submitStatsGlobalDTO else { return nil }

        let k = submitStatsGlobalDTO.acSubmissionDTOs?.map { acSubmissionDTO in
            ACSubmissionNumModel.from(acSubmissionNumDTO: acSubmissionDTO)
        }
        
        return SubmitStatsGlobalModel(acSubmissionNums: k)
    }
}

extension ProblemSolvedBeatsStatsModel {
    static func from(problemsSolvedBeatsStatsDTO: ProblemSolvedBeatsStatsDTO?) -> ProblemSolvedBeatsStatsModel? {
        guard let problemsSolvedBeatsStatsDTO else { return nil }

        return ProblemSolvedBeatsStatsModel(difficulty: problemsSolvedBeatsStatsDTO.difficulty, percentage: problemsSolvedBeatsStatsDTO.percentage)
    }

    static func from(problemsSolvedBeatsStatsDTO: [ProblemSolvedBeatsStatsDTO?]?) -> [ProblemSolvedBeatsStatsModel?]? {
        guard let problemsSolvedBeatsStatsDTO else { return nil }

        return problemsSolvedBeatsStatsDTO.map { stats in
            from(problemsSolvedBeatsStatsDTO: stats)
        }
    }
}
