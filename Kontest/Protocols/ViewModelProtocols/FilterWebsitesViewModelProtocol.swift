//
//  FilterWebsitesViewModelProtocol.swift
//  Kontest
//
//  Created by Ayush Singhal on 18/09/23.
//

import Foundation

protocol FilterWebsitesViewModelProtocol: Sendable {
    func getAllowedWebsites() -> [String]
}
