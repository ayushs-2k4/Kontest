//
//  Constants.swift
//  Kontest
//
//  Created by Ayush Singhal on 15/08/23.
//

import Foundation

enum Constants {
    static let minutesToBeReminderBefore = 10
    static let maximumDurationOfAKontestInMinutes = 12 * 60
    static let minimumDurationOfAKontestInMinutes = 0
    static let userDefaultsGroupID = "group.com.ayushsinghal.kontest"
    static let codeforcesNotAvailableErrorResponseMessage = "Codeforces is temporarily unavailable"

    static let maximumDurationOfAKontestInMinutesKey = "maximumDurationOfAKontestInMinutesKey"
    static let minimumDurationOfAKontestInMinutesKey = "minimumDurationOfAKontestInMinutesKey"

    static let minimumLimitOfMinutesOfKontest = 0
    static let maximumLimitOfMinutesOfKontest = 12 * 60

    static let states: [String] = ["Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chhattisgarh", "Dehradun", "Delhi", "Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jammu and Kashmir", "Jharkhand", "Karnataka", "Kerala", "Madhya Pradesh", "Maharashtra", "Manipur", "Meghalaya", "Mizoram", "Nagaland", "Odisha", "Puducherry", "Punjab", "Punjab and Haryana", "Rajasthan", "Sikkim", "Tamil Nadu", "Telangana", "Tripura", "Uttar Pradesh", "Uttarakhand", "West Bengal"]

    enum SiteAbbreviations: String {
        case AtCoder
        case CodeChef
        case CodeForces

        case CodeForcesGym = "CodeForces::Gym"

        case CodingNinjas = "Coding Ninjas"

        case CSAcademy = "CS Academy"

        case GeeksForGeeks = "Geeks For Geeks"

        case HackerEarth

        case HackerRank

        case LeetCode

        case ProjectEuler = "Project Euler"

        case TopCoder

        case Toph

        case YukiCoder = "Yuki Coder"

        case CupsOnline = "Cups Online"
    }
    
    static let automaticNotificationSuffix = "automaticNotificationSuffix"
    
    static let automaticCalendarEventSuffix = "automaticReminderSuffix"
}
