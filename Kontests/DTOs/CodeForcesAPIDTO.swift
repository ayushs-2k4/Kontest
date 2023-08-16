//
//  CodeForcesAPIDTO.swift
//  Kontests
//
//  Created by Ayush Singhal on 16/08/23.
//

import Foundation

// MARK: - CodeForcesAPIDTO
struct CodeForcesAPIDTO: Codable {
    let status: String
    let result: [CodeForcesResultDTO]
}

// MARK: - Result
struct CodeForcesResultDTO: Codable {
    let contestId: Int
    let contestName: String
    let handle: String
    let rank, ratingUpdateTimeSeconds, oldRating, newRating: Int

    enum CodingKeys: String, CodingKey {
        case contestId
        case contestName, handle, rank, ratingUpdateTimeSeconds, oldRating, newRating
    }
}
