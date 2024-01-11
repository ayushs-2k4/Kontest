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
class KontestModel: Codable, Identifiable, Hashable {
    enum CodingKeys: CodingKey {
        case id
        case name
        case url
        case start_time
        case end_time
        case duration
        case site
        case siteAbbreviation
        case in_24_hours
        case status
        case isSetForReminder10MiutesBefore
        case isSetForReminder30MiutesBefore
        case isSetForReminder1HourBefore
        case isSetForReminder6HoursBefore
        case logo
        case isCalendarEventAdded
        case calendarDate
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(String.self, forKey: .id) ?? "No ID"
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? "No Name"
        url = try container.decodeIfPresent(String.self, forKey: .url) ?? "No URL"
        start_time = try container.decodeIfPresent(String.self, forKey: .start_time) ?? "No Start Time"
        end_time = try container.decodeIfPresent(String.self, forKey: .end_time) ?? "No End Time"
        duration = try container.decodeIfPresent(String.self, forKey: .duration) ?? "-1"
        site = try container.decodeIfPresent(String.self, forKey: .site) ?? "No Site"
        siteAbbreviation = try container.decodeIfPresent(String.self, forKey: .siteAbbreviation) ?? "No Site"
        in_24_hours = try container.decodeIfPresent(String.self, forKey: .in_24_hours) ?? "N/A"
        status = try container.decodeIfPresent(KontestStatus.self, forKey: .status) ?? KontestStatus.OnGoing
        isSetForReminder10MiutesBefore = try container.decodeIfPresent(Bool.self, forKey: .isSetForReminder10MiutesBefore) ?? false
        isSetForReminder30MiutesBefore = try container.decodeIfPresent(Bool.self, forKey: .isSetForReminder30MiutesBefore) ?? false
        isSetForReminder1HourBefore = try container.decodeIfPresent(Bool.self, forKey: .isSetForReminder1HourBefore) ?? false
        isSetForReminder6HoursBefore = try container.decodeIfPresent(Bool.self, forKey: .isSetForReminder6HoursBefore) ?? false
        logo = try container.decodeIfPresent(String.self, forKey: .logo) ?? "No Logo"
        isCalendarEventAdded = try container.decodeIfPresent(Bool.self, forKey: .isCalendarEventAdded) ?? false
        calendarEventDate = try container.decodeIfPresent(Date.self, forKey: .calendarDate)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(url, forKey: .url)
        try container.encode(start_time, forKey: .start_time)
        try container.encode(end_time, forKey: .end_time)
        try container.encode(duration, forKey: .duration)
        try container.encode(site, forKey: .site)
        try container.encode(siteAbbreviation, forKey: .siteAbbreviation)
        try container.encode(in_24_hours, forKey: .in_24_hours)
        try container.encode(status, forKey: .status)
        try container.encode(calendarEventDate, forKey: .calendarDate)
    }

    let id: String
    let name: String
    let url: String
    let start_time, end_time, duration, site, in_24_hours: String
    var siteAbbreviation: String
    var status: KontestStatus
    var isSetForReminder10MiutesBefore: Bool
    var isSetForReminder30MiutesBefore: Bool
    var isSetForReminder1HourBefore: Bool
    var isSetForReminder6HoursBefore: Bool
    let logo: String
    var isCalendarEventAdded: Bool
    var calendarEventDate: Date?

    init(id: String, name: String, url: String, start_time: String, end_time: String, duration: String, site: String, in_24_hours: String, status: KontestStatus, logo: String) {
        self.id = id
        self.name = name
        self.url = url
        self.start_time = start_time
        self.end_time = end_time
        self.duration = duration
        self.site = site
        siteAbbreviation = KontestModel.getSiteAbbreviationFromSite(site: site)
        self.in_24_hours = in_24_hours
        self.status = status
        isSetForReminder10MiutesBefore = false
        isSetForReminder30MiutesBefore = false
        isSetForReminder1HourBefore = false
        isSetForReminder6HoursBefore = false
        self.logo = logo
        isCalendarEventAdded = false
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
    static func getSiteAbbreviationFromSite(site: String) -> String {
        switch site {
        case "atcoder.jp":
            "AtCoder"

        case "codechef.com":
            "CodeChef"

        case "codeforces.com":
            "CodeForces"

        case "codingninjas.com":
            "Coding Ninjas"

        case "codingninjas.com/codestudio":
            "Coding Ninjas"

        case "csacademy.com":
            "CS Academy"

        case "geeksforgeeks.org":
            "Geeks For Geeks"

        case "hackerearth.com":
            "HackerEarth"

        case "hackerrank.com":
            "HackerRank"

        case "leetcode.com":
            "LeetCode"

        case "projecteuler.net":
            "Project Euler"

        case "topcoder.com":
            "TopCoder"

        case "toph.com":
            "Toph"

        case "yukicoder.me":
            "Yuki Coder"

        default:
            site
        }
    }

    static func from(dto: KontestDTO) -> KontestModel {
        let id = generateUniqueID(dto: dto)

        let kontestStartDate = CalendarUtility.getDate(date: dto.start_time)
        let kontestEndDate = CalendarUtility.getDate(date: dto.end_time)

        var status: KontestStatus {
            return getKontestStatus(kontestStartDate: kontestStartDate ?? Date(), kontestEndDate: kontestEndDate ?? Date())
        }

        let duration = (kontestEndDate?.timeIntervalSince1970 ?? 0) - (kontestStartDate?.timeIntervalSince1970 ?? 0)

        return KontestModel(
            id: id,
            name: dto.name,
            url: dto.url,
            start_time: dto.start_time,
            end_time: dto.end_time,
            duration: "\(duration)",
            site: dto.site,
            in_24_hours: dto.in_24_hours,
            status: status,
            logo: getLogo(siteAbbreviation: dto.site)
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

    static func getColorForIdentifier(siteAbbreviation: String, colorScheme: ColorScheme = .light) -> Color {
        switch siteAbbreviation {
        case "AtCoder":
            Color(red: 187/255, green: 181/255, blue: 181/255)

        case "CodeChef":
            Color(red: 250/255, green: 155/255, blue: 101/255)

        case "CodeForces":
            .pink

        case "CodeForces::Gym":
            .red

        case "Coding Ninjas":
            .orange

        case "CS Academy":
            .red

        case "Geeks For Geeks":
            .green

        case "HackerEarth":
            Color(red: 101/255, green: 125/255, blue: 251/255)

        case "HackerRank":
            .green

        case "LeetCode":
            Color(red: 235/255, green: 162/255, blue: 64/255)

        case "Project Euler":
            Color(red: 103/255, green: 79/255, blue: 64/255)

        case "TopCoder":
            if colorScheme == .light {
                .black
            } else {
                .white
            }

        case "Toph":
            .blue

        case "Yuki Coder":
            Color(red: 60/255, green: 66/255, blue: 79/255)

        default:
            .red
        }
    }

    static func getLogo(siteAbbreviation: String, colorScheme: ColorScheme = .light) -> String {
        return switch siteAbbreviation {
        case "AtCoder":
            "AtCoder Logo"

        case "CodeChef":
            "CodeChef Logo"

        case "CodeForces":
            "CodeForces Logo"

        case "CodeForces::Gym":
            "CodeForces Logo"

        case "Coding Ninjas":
            "Coding Ninjas Logo"

        case "CS Academy":
            "CSAcademy Logo"

        case "Geeks For Geeks":
            "Geeks For Geeks Logo"

        case "HackerEarth":
            "HackerEarth Logo"

        case "HackerRank":
            "HackerRank Logo"

        case "LeetCode":
            if colorScheme == .light {
                "LeetCode Light Logo"
            } else if colorScheme == .dark {
                "LeetCode Dark Logo"
            } else {
                ""
            }

        case "Project Euler":
            "Project Euler Logo"

        case "TopCoder":
            if colorScheme == .light {
                "TopCoder Light Logo"
            } else if colorScheme == .dark {
                "TopCoder Dark Logo"
            } else { "" }

        case "Toph":
            "Toph Logo"

        case "Yuki Coder":
            "Yuki Coder Logo"

        default:
            "Placeholder Flag"
        }
    }

    // Save reminder status to UserDefaults
    func saveReminderStatus(minutesBefore: Int, hoursBefore: Int, daysBefore: Int) {
        let userDefaultsID = LocalNotificationManager.instance.getNotificationID(kontestID: id, minutesBefore: minutesBefore, hoursBefore: hoursBefore, daysBefore: daysBefore)

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
        var userDefaultsID = LocalNotificationManager.instance.getNotificationID(kontestID: id, minutesBefore: 10, hoursBefore: 0, daysBefore: 0)
        isSetForReminder10MiutesBefore = UserDefaults(suiteName: Constants.userDefaultsGroupID)!.bool(forKey: userDefaultsID)

        userDefaultsID = LocalNotificationManager.instance.getNotificationID(kontestID: id, minutesBefore: 30, hoursBefore: 0, daysBefore: 0)
        isSetForReminder30MiutesBefore = UserDefaults(suiteName: Constants.userDefaultsGroupID)!.bool(forKey: userDefaultsID)

        userDefaultsID = LocalNotificationManager.instance.getNotificationID(kontestID: id, minutesBefore: 0, hoursBefore: 1, daysBefore: 0)
        isSetForReminder1HourBefore = UserDefaults(suiteName: Constants.userDefaultsGroupID)!.bool(forKey: userDefaultsID)

        userDefaultsID = LocalNotificationManager.instance.getNotificationID(kontestID: id, minutesBefore: 0, hoursBefore: 6, daysBefore: 0)
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

    /// loads the calendar status of an event
    func loadCalendarStatus(allEvents: [EKEvent]) {
        let p = CalendarUtility.isEventPresentInCalendar(allEventsOfCalendar: allEvents, startDate: CalendarUtility.getDate(date: start_time) ?? Date(), endDate: CalendarUtility.getDate(date: end_time) ?? Date(), title: name, url: URL(string: url))

        isCalendarEventAdded = p
    }

    /// loads the date of first time notification of an event
    func loadCalendarEventDate(allEvents: [EKEvent]) {
        calendarEventDate = CalendarUtility.getCalendarDateOfEvent(allEventsOfCalendar: allEvents, startDate: CalendarUtility.getDate(date: start_time) ?? Date(), endDate: CalendarUtility.getDate(date: end_time) ?? Date(), title: name, url: URL(string: url))
    }

    static var example: KontestModel {
        KontestModel.from(dto: KontestDTO(name: "ProjectEuler+1", url: "https://hackerrank.com/contests/projecteuler", start_time: "2023-08-15 18:29:00 UTC", end_time: "2023-08-18 17:43:00 UTC", duration: "1020.0", site: "HackerRank", in_24_hours: "No", status: "BEFORE"))
    }
}
