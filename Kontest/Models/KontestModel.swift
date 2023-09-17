//
//  KontestModel.swift
//  Kontest
//
//  Created by Ayush Singhal on 14/08/23.
//

import CryptoKit
import EventKit
import SwiftUI

@Observable
class KontestModel: Decodable, Identifiable, Hashable {
    let id: String
    let name: String
    let url: String
    let start_time, end_time, duration, site, in_24_hours: String
    var status: KontestStatus
    var isSetForReminder10MiutesBefore: Bool
    var isSetForReminder30MiutesBefore: Bool
    var isSetForReminder1HourBefore: Bool
    var isSetForReminder6HoursBefore: Bool
    let logo: String
    var isCalendarEventAdded: Bool

    init(id: String, name: String, url: String, start_time: String, end_time: String, duration: String, site: String, in_24_hours: String, status: KontestStatus, logo: String) {
        self.id = id
        self.name = name
        self.url = url
        self.start_time = start_time
        self.end_time = end_time
        self.duration = duration
        self.site = site
        self.in_24_hours = in_24_hours
        self.status = status
        self.isSetForReminder10MiutesBefore = false
        self.isSetForReminder30MiutesBefore = false
        self.isSetForReminder1HourBefore = false
        self.isSetForReminder6HoursBefore = false
        self.logo = logo
        self.isCalendarEventAdded = false
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension KontestModel: Equatable {
    static func == (lhs: KontestModel, rhs: KontestModel) -> Bool {
        return lhs.id == rhs.id
    }
}

extension KontestModel {
    static func from(dto: KontestDTO) -> KontestModel {
        let id = generateUniqueID(dto: dto)

        var status: KontestStatus {
            let kontestStartDate = CalendarUtility.getDate(date: dto.start_time)
            let kontestEndDate = CalendarUtility.getDate(date: dto.end_time)

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
            .pink

        case "CodeForces::Gym":
            .red

        case "AtCoder":
            Color(red: 187/255, green: 181/255, blue: 181/255)

        case "CS Academy":
            .red

        case "CodeChef":
            Color(red: 250/255, green: 155/255, blue: 101/255)

        case "HackerRank":
            .green

        case "HackerEarth":
            Color(red: 101/255, green: 125/255, blue: 251/255)

        case "LeetCode":
            Color(red: 235/255, green: 162/255, blue: 64/255)

        case "Toph":
            .blue

        default:
            .red
        }
    }

    static func getLogo(site: String) -> String {
        return switch site {
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
            "LeetCode Dark Logo"

        case "Toph":
            "Toph Logo"

        default:
            "CodeForces Logo"
        }
    }

    // Save reminder status to UserDefaults
    func saveReminderStatus(minutesBefore: Int = Constants.minutesToBeReminderBefore, hoursBefore: Int = 0, daysBefore: Int = 0) {
        let userDefaultsID = id + "\(minutesBefore)\(hoursBefore)\(daysBefore)"

        if minutesBefore == 10 {
            UserDefaults(suiteName: Constants.userDefaultsGroupID)!.set(isSetForReminder10MiutesBefore, forKey: userDefaultsID)
        } else if minutesBefore == 30 {
            UserDefaults(suiteName: Constants.userDefaultsGroupID)!.set(isSetForReminder30MiutesBefore, forKey: userDefaultsID)
        } else if hoursBefore == 1 {
            UserDefaults(suiteName: Constants.userDefaultsGroupID)!.set(isSetForReminder1HourBefore, forKey: userDefaultsID)
        } else {
            UserDefaults(suiteName: Constants.userDefaultsGroupID)!.set(isSetForReminder6HoursBefore, forKey: userDefaultsID)
        }
    }

    // Load reminder status from UserDefaults
    func loadReminderStatus() {
        var userDefaultsID = id + "10" + "0" + "0"
        isSetForReminder10MiutesBefore = UserDefaults(suiteName: Constants.userDefaultsGroupID)!.bool(forKey: userDefaultsID)

        userDefaultsID = id + "30" + "0" + "0"
        isSetForReminder30MiutesBefore = UserDefaults(suiteName: Constants.userDefaultsGroupID)!.bool(forKey: userDefaultsID)

        userDefaultsID = id + "0" + "1" + "0"
        isSetForReminder1HourBefore = UserDefaults(suiteName: Constants.userDefaultsGroupID)!.bool(forKey: userDefaultsID)

        userDefaultsID = id + "0" + "6" + "0"
        isSetForReminder6HoursBefore = UserDefaults(suiteName: Constants.userDefaultsGroupID)!.bool(forKey: userDefaultsID)
    }

    func removeReminderStatusFromUserDefaults() {
        UserDefaults(suiteName: Constants.userDefaultsGroupID)!.removeObject(forKey: id)
    }

    static func getKontestStatus(kontestStartDate: Date, kontestEndDate: Date) -> KontestStatus {
        if CalendarUtility.isKontestRunning(kontestStartDate: kontestStartDate, kontestEndDate: kontestEndDate) {
            .OnGoing
        } else if CalendarUtility.isKontestLaterToday(kontestStartDate: kontestStartDate) {
            .LaterToday
        } else if CalendarUtility.isKontestTomorrow(kontestStartDate: kontestStartDate) {
            .Tomorrow
        } else {
            .Later
        }
    }

    func loadCalendarStatus(allEvents: [EKEvent]) {
        isCalendarEventAdded = CalendarUtility.isEventPresentInCalendar(allEventsOfCalendar: allEvents, startDate: CalendarUtility.getDate(date: start_time) ?? Date(), endDate: CalendarUtility.getDate(date: end_time) ?? Date(), title: name, url: URL(string: url))
    }
}
