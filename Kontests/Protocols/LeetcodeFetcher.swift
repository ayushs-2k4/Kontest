//
//  LeetcodeFetcher.swift
//  Kontests
//
//  Created by Ayush Singhal on 16/08/23.
//

import Foundation

protocol LeetcodeFetcher {
    func getUserData(username: String) async throws -> LeetcodeAPIDTO
}
