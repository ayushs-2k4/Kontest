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
    case topCodeKey
    case yukiCoderKey
}

func setDefaultValuesForFilterWebsiteKeysToTrue() {
    let logger = Logger(subsystem: "com.ayushsinghal.Kontest", category: "FilterWebsiteKey")

    let userDefaults = UserDefaults(suiteName: Constants.userDefaultsGroupID)!

    FilterWebsiteKey.allCases.forEach { filterWebsiteKey in
        if userDefaults.value(forKey: filterWebsiteKey.rawValue) == nil {
            logger.info("Ran1: \(filterWebsiteKey.rawValue): \(userDefaults.bool(forKey: filterWebsiteKey.rawValue))")
            userDefaults.setValue(true, forKey: filterWebsiteKey.rawValue)
            logger.info("Ran2: \(filterWebsiteKey.rawValue): \(userDefaults.bool(forKey: filterWebsiteKey.rawValue))")
        } else {
            logger.info("Not Ran: \(filterWebsiteKey.rawValue): \(userDefaults.bool(forKey: filterWebsiteKey.rawValue))")
        }
    }
}
