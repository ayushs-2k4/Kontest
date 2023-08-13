//
//  KontestModel.swift
//  Kontests
//
//  Created by Ayush Singhal on 14/08/23.
//

import CryptoKit
import SwiftUI

struct KontestModel: Decodable, Identifiable, Equatable {
    let id: String
    let name: String
    let url: String
    let start_time, end_time, duration, site: String
    let in_24_hours, status: String
    var isSetForReminder: Bool
    let logo: String
}

extension KontestModel {
    static func from(dto: KontestDTO) -> KontestModel {
        let id = generateUniqueID(dto: dto)
        let isSetForReminder = false

        return KontestModel(
            id: id,
            name: dto.name,
            url: dto.url,
            start_time: dto.start_time,
            end_time: dto.end_time,
            duration: dto.duration,
            site: dto.site,
            in_24_hours: dto.in_24_hours,
            status: dto.status,
            isSetForReminder: isSetForReminder,
            logo: getLogo(site: dto.site)
        )
    }

    private static func generateUniqueID(dto: KontestDTO) -> String {
        let combinedString = "\(dto.name)\(dto.url)\(dto.start_time)\(dto.end_time)\(dto.duration)\(dto.site)\(dto.in_24_hours)\(dto.status)"

        if let data = combinedString.data(using: .utf8) {
            let hash = SHA256.hash(data: data)
            return hash.compactMap { String(format: "%02x", $0) }.joined()
        } else {
            return UUID().uuidString
        }
    }

    static func getColorForIdentifier(site: String) -> Color {
        switch site {
        case "CodeForces":
            .red

        case "CodeForces::Gym":
            .red

        case "AtCoder":
            .brown

        case "CS Academy":
            .red

        case "CodeChef":
            .brown

        case "HackerRank":
            .green

        case "HackerEarth":
            Color(red: 40, green: 44, blue: 67)

        case "LeetCode":
            .yellow

        case "Toph":
            .blue

        default:
            .red
        }
    }

    static func getLogo(site: String) -> String {
        switch site {
        case "CodeForces":
            "CodeForces Logo"

        case "CodeForces::Gym":
            "CodeForces Logo"

        case "AtCoder":
            "AtCoder Logo"

        case "CS Academy":
            "CSAcademy Logo"

        case "CodeChef":
            "CodeChef Logo"

        case "HackerRank":
            "HackerRank Logo"

        case "HackerEarth":
            "HackerEarth Logo"

        case "LeetCode":
            "LeetCode Logo"

        case "Toph":
            "Toph Logo"

        default:
            "CodeForces Logo"
        }
    }

    mutating func toggleIsSetForReminder() {
        isSetForReminder.toggle()
    }
}
