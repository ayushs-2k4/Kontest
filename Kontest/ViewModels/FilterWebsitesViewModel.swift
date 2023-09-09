//
//  FilterWebsitesViewModel.swift
//  Kontest
//
//  Created by Ayush Singhal on 09/09/23.
//

import Foundation

class FilterWebsitesViewModel {
    func getAllowedWebsites() -> [String] {
        var allowedWebsites: [String] = []

        print("Ran addAllowedWebsites()")

        if UserDefaults.standard.bool(forKey: FilterWebsiteKey.codeForcesKey.rawValue) {
            allowedWebsites.append("CodeForces")
        }

        if UserDefaults.standard.bool(forKey: FilterWebsiteKey.atCoderKey.rawValue) {
            allowedWebsites.append("AtCoder")
        }

        if UserDefaults.standard.bool(forKey: FilterWebsiteKey.cSAcademyKey.rawValue) {
            allowedWebsites.append("CS Academy")
        }

        if UserDefaults.standard.bool(forKey: FilterWebsiteKey.codeChefKey.rawValue) {
            allowedWebsites.append("CodeChef")
        }

        if UserDefaults.standard.bool(forKey: FilterWebsiteKey.hackerRankKey.rawValue) {
            allowedWebsites.append("HackerRank")
        }

        if UserDefaults.standard.bool(forKey: FilterWebsiteKey.hackerEarthKey.rawValue) {
            allowedWebsites.append("HackerEarth")
        }

        if UserDefaults.standard.bool(forKey: FilterWebsiteKey.leetCodeKey.rawValue) {
            allowedWebsites.append("LeetCode")
        }

        if UserDefaults.standard.bool(forKey: FilterWebsiteKey.tophKey.rawValue) {
            allowedWebsites.append("Toph")
        }
        
        return allowedWebsites
    }
}
