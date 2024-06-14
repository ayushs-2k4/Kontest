//
//  KontestFetcher.swift
//  Kontest
//
//  Created by Ayush Singhal on 13/08/23.
//

import Foundation

protocol KontestFetcher: Sendable {
    func getAllKontests() async throws -> [KontestDTO]
}
