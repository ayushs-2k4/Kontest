//
//  CodeForcesFetcher.swift
//  Kontest
//
//  Created by Ayush Singhal on 16/08/23.
//

import Foundation

protocol CodeForcesFetcher {
    func getUserData(username: String) async throws -> CodeForcesAPIDTO
}
