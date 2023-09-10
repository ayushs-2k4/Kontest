//
//  FilterWebsiteKey.swift
//  Kontest
//
//  Created by Ayush Singhal on 09/09/23.
//

import Foundation

enum FilterWebsiteKey: String, CaseIterable {
    case codeForcesKey
    case atCoderKey
    case cSAcademyKey
    case codeChefKey
    case hackerRankKey
    case hackerEarthKey
    case leetCodeKey
    case tophKey
}

func setDefaultValuesForFilterWebsiteKeysToTrue() {
    let userDefaults = UserDefaults.standard

    FilterWebsiteKey.allCases.forEach { filterWebsiteKey in
        userDefaults.register(defaults: [filterWebsiteKey.rawValue: true])
    }
}
