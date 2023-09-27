//
//  KontestDTO.swift
//  Kontest
//
//  Created by Ayush Singhal on 12/08/23.
//

import CryptoKit
import Foundation

struct KontestDTO: Codable {
    let name: String
    let url: String
    let start_time, end_time, duration, site: String
    let in_24_hours, status: String
}
