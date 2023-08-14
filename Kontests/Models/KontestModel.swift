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
    let start_time, end_time, duration, site, in_24_hours: String
    var status: KontestStatus
    var isSetForReminder: Bool
    let logo: String
}

extension KontestModel {
    static func from(dto: KontestDTO) -> KontestModel {
        let id = generateUniqueID(dto: dto)
        let isSetForReminder = false

        var status: KontestStatus {
            let kontestStartDate = DateUtility.getDate(date: dto.start_time)
            let kontestEndDate = DateUtility.getDate(date: dto.end_time)

            return getKontestStatus(kontestStartDate: kontestStartDate ?? Date(), kontestEndDate: kontestEndDate ?? Date())
        }

        return KontestModel(
            id: id,
            name: dto.name,
            url: dto.url,
            start_time: dto.start_time,
            end_time: dto.end_time,
            duration: dto.duration,
            site: dto.site,
            in_24_hours: dto.in_24_hours,
            status: status,
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

    // Save reminder status to UserDefaults
    func saveReminderStatus() {
        UserDefaults.standard.set(isSetForReminder, forKey: id)
    }

    // Load reminder status from UserDefaults
    mutating func loadReminderStatus() {
        isSetForReminder = UserDefaults.standard.bool(forKey: id)
    }

    func removeReminderStatusFromUserDefaults() {
        UserDefaults.standard.removeObject(forKey: id)
    }

    static func getKontestStatus(kontestStartDate: Date, kontestEndDate: Date) -> KontestStatus {
        if DateUtility.isKontestOfFuture(kontestStartDate: kontestStartDate) {
            .Upcoming
        } else if DateUtility.isKontestOfPast(kontestEndDate: kontestEndDate) {
            .Ended
        } else {
            .Running
        }
    }

    func updateKontestStatus() -> KontestStatus {
        let kontestStartDate = DateUtility.getDate(date: start_time) ?? Date()
        let kontestEndDate = DateUtility.getDate(date: end_time) ?? Date()

        if DateUtility.isKontestOfFuture(kontestStartDate: kontestStartDate) {
            return .Upcoming
        } else if DateUtility.isKontestOfPast(kontestEndDate: kontestEndDate) {
            return .Ended
        } else {
            return .Running
        }
    }
}
