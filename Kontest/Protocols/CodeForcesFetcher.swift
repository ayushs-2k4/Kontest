//
//  CodeForcesFetcher.swift
//  Kontest
//
//  Created by Ayush Singhal on 16/08/23.
//

import Foundation

protocol CodeForcesFetcher: Sendable {
    func getUserRating(username: String) async throws -> CodeForcesUserRatingAPIDTO
    func getUserInfo(username: String) async throws -> CodeForcesUserInfoAPIDTO
}
