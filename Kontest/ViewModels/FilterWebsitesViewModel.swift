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
            allowedWebsites.append("CodeForces")
            allowedWebsites.append("CodeForces::Gym")
        }

        if userDefaults.bool(forKey: FilterWebsiteKey.atCoderKey.rawValue) {
            allowedWebsites.append("AtCoder")
        }

        if userDefaults.bool(forKey: FilterWebsiteKey.cSAcademyKey.rawValue) {
            allowedWebsites.append("CS Academy")
        }

        if userDefaults.bool(forKey: FilterWebsiteKey.codeChefKey.rawValue) {
            allowedWebsites.append("CodeChef")
        }

        if userDefaults.bool(forKey: FilterWebsiteKey.hackerRankKey.rawValue) {
            allowedWebsites.append("HackerRank")
        }

        if userDefaults.bool(forKey: FilterWebsiteKey.hackerEarthKey.rawValue) {
            allowedWebsites.append("HackerEarth")
        }

        if userDefaults.bool(forKey: FilterWebsiteKey.leetCodeKey.rawValue) {
            allowedWebsites.append("LeetCode")
        }

        if userDefaults.bool(forKey: FilterWebsiteKey.tophKey.rawValue) {
            allowedWebsites.append("Toph")
        }

        return allowedWebsites
    }
}
