//
//  KontestDTO.swift
//  Kontests
//
//  Created by Ayush Singhal on 12/08/23.
//

import CryptoKit
import Foundation

struct KontestDTO: Codable, Identifiable {
    var id: String { generateUniqueID() }

    let name: String
    let url: String
    let start_time, end_time, duration, site: String
    let in_24_hours, status: String

    private func generateUniqueID() -> String {
        let combinedString = "\(name)\(url)\(start_time)\(end_time)\(duration)\(site)\(in_24_hours)\(status)"

        if let data = combinedString.data(using: .utf8) {
            let hash = SHA256.hash(data: data)
            return hash.compactMap { String(format: "%02x", $0) }.joined()
        } else {
            return UUID().uuidString
        }
    }
}
