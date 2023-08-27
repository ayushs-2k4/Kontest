//
//  LeetcodeAPIDTO.swift
//  Kontest
//
//  Created by Ayush Singhal on 16/08/23.
//

import Foundation

// MARK: - LeetcodeAPIDTO

struct LeetcodeAPIDTO: Codable {
    let status, message: String
    let totalSolved, totalQuestions, easySolved, totalEasy: Int
    let mediumSolved, totalMedium, hardSolved, totalHard: Int
    let acceptanceRate: Double
    let ranking, contributionPoints, reputation: Int
    let submissionCalendar: [String: Int]
}
