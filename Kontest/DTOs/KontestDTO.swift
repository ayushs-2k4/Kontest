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
    let startTime: String
    let endTime: String
    let duration: String
    let site: String
    let in_24_hours: String
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case url
        case startTime
        case endTime
        case duration
        case site
        case in_24_hours
        case status
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        url = try container.decode(String.self, forKey: .url)
        startTime = try container.decode(String.self, forKey: .startTime)
        endTime = try container.decode(String.self, forKey: .endTime)
        
        // Provide default values for missing properties
        duration = (try? container.decode(String.self, forKey: .duration)) ?? ""
        site = (try? container.decode(String.self, forKey: .site)) ?? ""
        in_24_hours = (try? container.decode(String.self, forKey: .in_24_hours)) ?? ""
        status = (try? container.decode(String.self, forKey: .status)) ?? ""
    }
    
    init(name: String, url: String, startTime: String, endTime: String, duration: String, site: String, in_24_hours: String, status: String) {
        self.name = name
        self.url = url
        self.startTime = startTime
        self.endTime = endTime
        self.duration = duration
        self.site = site
        self.in_24_hours = in_24_hours
        self.status = status
    }
}
