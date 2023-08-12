//
//  Kontest.swift
//  Coding Contest
//
//  Created by Ayush Singhal on 12/08/23.
//

import Foundation

struct Kontest: Codable, Identifiable {
    let id = UUID().uuidString
    let name: String
    let url: String
    let start_time, end_time, duration, site: String
    let in_24_hours, status: String
    
    
}
