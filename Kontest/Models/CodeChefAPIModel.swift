//
//  CodechefAPIModel.swift
//  Kontest
//
//  Created by Ayush Singhal on 27/08/23.
//

import Foundation

struct CodeChefAPIModel: Codable {
    let success: Bool
    let profile: String
    let name: String
    let currentRating, highestRating: Int
    let countryFlag: String
    let countryName: String
    let globalRank, countryRank: Int
    let stars: String
}

extension CodeChefAPIModel {
    static func from(codeChefAPIDTO: CodeChefAPIDTO) -> CodeChefAPIModel {
        return CodeChefAPIModel(success: codeChefAPIDTO.success, profile: codeChefAPIDTO.profile, name: codeChefAPIDTO.name, currentRating: codeChefAPIDTO.currentRating, highestRating: codeChefAPIDTO.highestRating, countryFlag: codeChefAPIDTO.countryFlag, countryName: codeChefAPIDTO.countryName, globalRank: codeChefAPIDTO.globalRank, countryRank: codeChefAPIDTO.countryRank, stars: codeChefAPIDTO.stars)
    }
}
