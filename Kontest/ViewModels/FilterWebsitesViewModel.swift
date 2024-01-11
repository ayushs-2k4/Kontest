//
//  FilterWebsitesViewModel.swift
//  Kontest
//
//  Created by Ayush Singhal on 09/09/23.
//

import Foundation
import OSLog

class FilterWebsitesViewModel: FilterWebsitesViewModelProtocol {
    private let logger = Logger(subsystem: "com.ayushsinghal.Kontest", category: "FilterWebsitesViewModel")

    func getAllowedWebsites() -> [String] {
        var allowedWebsites: [String] = []

        logger.info("Ran addAllowedWebsites()")

        let userDefaults = UserDefaults(suiteName: Constants.userDefaultsGroupID)!

        if userDefaults.bool(forKey: FilterWebsiteKey.codeForcesKey.rawValue) {
            allowedWebsites.append("codeforces.com")
        }

        if userDefaults.bool(forKey: FilterWebsiteKey.atCoderKey.rawValue) {
            allowedWebsites.append("atcoder.jp")
        }

        if userDefaults.bool(forKey: FilterWebsiteKey.cSAcademyKey.rawValue) {
            allowedWebsites.append("csacademy.com")
        }

        if userDefaults.bool(forKey: FilterWebsiteKey.codeChefKey.rawValue) {
            allowedWebsites.append("codechef.com")
        }

        if userDefaults.bool(forKey: FilterWebsiteKey.hackerRankKey.rawValue) {
            allowedWebsites.append("hackerrank.com")
        }

        if userDefaults.bool(forKey: FilterWebsiteKey.hackerEarthKey.rawValue) {
            allowedWebsites.append("hackerearth.com")
        }

        if userDefaults.bool(forKey: FilterWebsiteKey.leetCodeKey.rawValue) {
            allowedWebsites.append("leetcode.com")
        }

        if userDefaults.bool(forKey: FilterWebsiteKey.tophKey.rawValue) {
            allowedWebsites.append("toph.co")
        }

        if userDefaults.bool(forKey: FilterWebsiteKey.codingNinjasKey.rawValue) {
            allowedWebsites.append("codingninjas.com/codestudio")
        }

        if userDefaults.bool(forKey: FilterWebsiteKey.projectEulerKey.rawValue) {
            allowedWebsites.append("projecteuler.net")
        }

        if userDefaults.bool(forKey: FilterWebsiteKey.topCodeKey.rawValue) {
            allowedWebsites.append("topcoder.com")
        }

        if userDefaults.bool(forKey: FilterWebsiteKey.yukiCoderKey.rawValue) {
            allowedWebsites.append("yukicoder.me")
        }

        if userDefaults.bool(forKey: FilterWebsiteKey.geeksForGeeksKey.rawValue) {
            allowedWebsites.append("geeksforgeeks.org")
        }

        return allowedWebsites
    }
}
