//
//  CodeForcesUserRatingAPIDTO.swift
//  Kontest
//
//  Created by Ayush Singhal on 16/08/23.
//

import Foundation

// MARK: - CodeForcesUserRatingAPIDTO
struct CodeForcesUserRatingAPIDTO: Codable {
    let status: String
    let result: [CodeForcesUserRatingAPIResultDTO]
}

// MARK: - CodeForcesUserRatingAPIResultDTO
struct CodeForcesUserRatingAPIResultDTO: Codable {
    let contestId: Int
    let contestName: String
    let handle: String
    let rank, ratingUpdateTimeSeconds, oldRating, newRating: Int

    enum CodingKeys: String, CodingKey {
        case contestId
        case contestName, handle, rank, ratingUpdateTimeSeconds, oldRating, newRating
    }
}
