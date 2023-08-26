//
//  CodeForcesUserInfoAPIDTO.swift
//  Kontest
//
//  Created by Ayush Singhal on 26/08/23.
//

import Foundation

// MARK: - CodeForcesUserInfoDTO

struct CodeForcesUserInfoAPIDTO:Codable {
    let status: String
    let result: [CodeForcesUserInfoAPIResultDTO]
}

// MARK: - CodeForcesUserInfoAPIResultDTO

struct CodeForcesUserInfoAPIResultDTO: Codable {
    let contribution, lastOnlineTimeSeconds, rating, friendOfCount: Int
    let titlePhoto: String
    let rank, handle: String
    let maxRating: Int
    let avatar: String
    let registrationTimeSeconds: Int
    let maxRank: String
}
