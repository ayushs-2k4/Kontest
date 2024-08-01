//
//  KontestDTO.swift
//  Kontest
//
//  Created by Ayush Singhal on 12/08/23.
//

import CryptoKit
import Foundation

import Foundation

struct KontestDTO: Codable {
    let name: String
    let url: String
    let start_time: String
    let end_time: String
    let duration: String
    let site: String
    let in_24_hours: String
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case url
        case start_time
        case end_time
        case duration
        case site
        case in_24_hours
        case status
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        url = try container.decode(String.self, forKey: .url)
        start_time = try container.decode(String.self, forKey: .start_time)
        end_time = try container.decode(String.self, forKey: .end_time)
        
        // Provide default values for missing properties
        duration = (try? container.decode(String.self, forKey: .duration)) ?? ""
        site = (try? container.decode(String.self, forKey: .site)) ?? ""
        in_24_hours = (try? container.decode(String.self, forKey: .in_24_hours)) ?? ""
        status = (try? container.decode(String.self, forKey: .status)) ?? ""
    }
    
    init(name: String, url: String, start_time: String, end_time: String, duration: String, site: String, in_24_hours: String, status: String) {
        self.name = name
        self.url = url
        self.start_time = start_time
        self.end_time = end_time
        self.duration = duration
        self.site = site
        self.in_24_hours = in_24_hours
        self.status = status
    }
}
