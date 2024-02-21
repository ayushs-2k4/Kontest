//
//  FilterWebsiteKey.swift
//  Kontest
//
//  Created by Ayush Singhal on 09/09/23.
//

import Foundation
import OSLog

enum FilterWebsiteKey: String, CaseIterable {
    case atCoderKey
    case codeChefKey
    case codeForcesKey
    case cSAcademyKey
    case hackerEarthKey
    case hackerRankKey
    case leetCodeKey
    case tophKey

    case codingNinjasKey
    case geeksForGeeksKey
    case projectEulerKey
    case topCoderKey
    case yukiCoderKey

    case cupsOnlineKey
}

/// Add something as prefix or suffix before using as Key
func getAllSiteAbbreviations() -> [String] {
    return [
        Constants.SiteAbbreviations.AtCoder.rawValue,

        Constants.SiteAbbreviations.CodeChef.rawValue,

        Constants.SiteAbbreviations.CodeForces.rawValue,

        Constants.SiteAbbreviations.CodingNinjas.rawValue,

        Constants.SiteAbbreviations.CodingNinjas.rawValue,

        Constants.SiteAbbreviations.CSAcademy.rawValue,

        Constants.SiteAbbreviations.GeeksForGeeks.rawValue,

        Constants.SiteAbbreviations.HackerEarth.rawValue,

        Constants.SiteAbbreviations.HackerRank.rawValue,

        Constants.SiteAbbreviations.LeetCode.rawValue,

        Constants.SiteAbbreviations.ProjectEuler.rawValue,

        Constants.SiteAbbreviations.TopCoder.rawValue,

        Constants.SiteAbbreviations.Toph.rawValue,

        Constants.SiteAbbreviations.YukiCoder.rawValue,

        Constants.SiteAbbreviations.CupsOnline.rawValue
    ]
}

func setDefaultValuesForFilterWebsiteKeysToTrue() {
    let logger = Logger(subsystem: "com.ayushsinghal.Kontest", category: "setDefaultValuesForFilterWebsiteKeysToTrue")

    let userDefaults = UserDefaults(suiteName: Constants.userDefaultsGroupID)!

    for filterWebsiteKey in FilterWebsiteKey.allCases {
        if userDefaults.value(forKey: filterWebsiteKey.rawValue) == nil {
            logger.info("Ran1: \(filterWebsiteKey.rawValue): \(userDefaults.bool(forKey: filterWebsiteKey.rawValue))")
            userDefaults.setValue(true, forKey: filterWebsiteKey.rawValue)
            logger.info("Ran2: \(filterWebsiteKey.rawValue): \(userDefaults.bool(forKey: filterWebsiteKey.rawValue))")
        } else {
            logger.info("Not Ran: \(filterWebsiteKey.rawValue): \(userDefaults.bool(forKey: filterWebsiteKey.rawValue))")
        }
    }
}

func setDefaultValuesForMinAndMaxDurationKeys() {
    let userDefaults = UserDefaults(suiteName: Constants.userDefaultsGroupID)!

    if userDefaults.value(forKey: Constants.minimumDurationOfAKontestInMinutesKey) == nil {
        userDefaults.setValue(Constants.minimumLimitOfMinutesOfKontest, forKey: Constants.minimumDurationOfAKontestInMinutesKey)
    }

    if userDefaults.value(forKey: Constants.maximumDurationOfAKontestInMinutesKey) == nil {
        userDefaults.setValue(Constants.maximumLimitOfMinutesOfKontest, forKey: Constants.maximumDurationOfAKontestInMinutesKey)
    }
}

func setDefaultValuesForAutomaticCalendarEventToFalse() {
    let userDefaults = UserDefaults(suiteName: Constants.userDefaultsGroupID)!

    for siteAbbreviation in getAllSiteAbbreviations() {
        let newKey = siteAbbreviation + Constants.automaticCalendarEventSuffix

        if userDefaults.value(forKey: newKey) == nil {
            userDefaults.setValue(false, forKey: newKey)
        }
    }
}
