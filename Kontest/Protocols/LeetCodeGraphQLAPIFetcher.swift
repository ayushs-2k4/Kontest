//
//  LeetCodeGraphQLAPIFetcher.swift
//  Kontest
//
//  Created by Ayush Singhal on 04/09/23.
//

import Foundation

protocol LeetCodeGraphQLAPIFetcher: Sendable {
    func getUserData(username: String, completion: @escaping (LeetCodeUserProfileGraphQLAPIDTO?, Error?) -> Void)

    func getUserRankingInfo(username: String, completion: @escaping (LeetCodeUserRankingsGraphQLAPIDTO?,Error?) -> Void)
}
