//
//  CodeChefScrapingContestDTO.swift
//  Kontest
//
//  Created by Ayush Singhal on 1/13/24.
//

import Foundation

struct CodeChefScrapingContestDTO: Codable {
    let code: String
    let getyear: String
    let getmonth: String
    let getday: String
    let reason: String?
    let penalised_in: String?
    let rating: String
    let rank: String
    let name: String
    let end_date: String
    let color: String
}
