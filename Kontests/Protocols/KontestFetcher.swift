//
//  KontestFetcher.swift
//  Kontests
//
//  Created by Ayush Singhal on 13/08/23.
//

import Foundation

protocol KontestFetcher{
    func getAllKontests() async throws -> [Kontest]
}
