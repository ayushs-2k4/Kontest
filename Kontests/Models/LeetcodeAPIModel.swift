//
//  LeetcodeAPIModel.swift
//  Kontests
//
//  Created by Ayush Singhal on 16/08/23.
//

import Foundation

struct LeetcodeAPIModel: Codable {
    let status, message: String
    let totalSolved, totalQuestions, easySolved, totalEasy: Int
    let mediumSolved, totalMedium, hardSolved, totalHard: Int
    let acceptanceRate: Double
    let ranking, contributionPoints, reputation: Int
    let submissionCalendar: [String: Int]
}

extension LeetcodeAPIModel {
    static func from(dto: LeetcodeAPIDTO) -> LeetcodeAPIModel {
        return LeetcodeAPIModel(
            status: dto.status,
            message: dto.message,
            totalSolved: dto.totalSolved,
            totalQuestions: dto.totalQuestions,
            easySolved: dto.easySolved,
            totalEasy: dto.totalEasy,
            mediumSolved: dto.mediumSolved,
            totalMedium: dto.totalMedium,
            hardSolved: dto.hardSolved,
            totalHard: dto.totalHard,
            acceptanceRate: dto.acceptanceRate,
            ranking: dto.ranking,
            contributionPoints: dto.contributionPoints,
            reputation: dto.reputation,
            submissionCalendar: dto.submissionCalendar
        )
    }
}
