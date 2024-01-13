//
//  CodeChefScrapingContestModel.swift
//  Kontest
//
//  Created by Ayush Singhal on 1/13/24.
//

import Foundation

struct CodeChefScrapingContestModel: Codable {
    let code: String
    let year: String
    let month: String
    let day: String
    let reason: String?
    let penalised_in: String?
    let rating: String
    let rank: String
    let name: String
    let endDate: String
    let color: String
}

extension CodeChefScrapingContestModel {
    static func from(dto: CodeChefScrapingContestDTO) -> CodeChefScrapingContestModel {
        return CodeChefScrapingContestModel(
            code: dto.code,
            year: dto.getyear,
            month: dto.getmonth,
            day: dto.getday,
            reason: dto.reason,
            penalised_in: dto.penalised_in,
            rating: dto.rating,
            rank: dto.rank,
            name: dto.name,
            endDate: dto.end_date,
            color: dto.color
        )
    }
}
