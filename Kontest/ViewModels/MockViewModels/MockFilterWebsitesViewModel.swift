//
//  MockFilterWebsitesViewModel.swift
//  Kontest
//
//  Created by Ayush Singhal on 18/09/23.
//

import Foundation

final class MockFilterWebsitesViewModel: FilterWebsitesViewModelProtocol {
    let allowedWebsites: [String]
    
    init(allowedWebsites: [String] = ["LeetCode", "CodeChef"]) {
        self.allowedWebsites = allowedWebsites
    }
    
    func getAllowedWebsites() -> [String] {
        return allowedWebsites
    }
}
