//
//  CodeChefScrapingAPIRepository.swift
//  Kontest
//
//  Created by Ayush Singhal on 1/13/24.
//

import Foundation
import OSLog
import SwiftSoup

func getUserDataFromParsedHTML(stringHTML: String) -> String {
    let startIndex = stringHTML.ranges(of: "var all_rating =")
    let endIndex = stringHTML.ranges(of: "var current_user_rating")

    var prefinalString = stringHTML[startIndex[0].upperBound ..< endIndex[0].lowerBound]

    let indOfSemiColon = prefinalString.ranges(of: ";")

    prefinalString.removeSubrange(indOfSemiColon[0].lowerBound ..< prefinalString.endIndex)

    let indOfFirstBigBracket = prefinalString.ranges(of: "[")

    prefinalString.removeSubrange(prefinalString.startIndex ..< indOfFirstBigBracket[0].lowerBound)

    return String(prefinalString)
}

class CodeChefScrapingAPIRepository {
    private let logger = Logger(subsystem: "com.ayushsinghal.Kontest", category: "CodeChefAPIRepository")

    func getUserKontests(username: String) async throws -> [CodeChefScrapingContestDTO] {
        guard let url = URL(string: "https://www.codechef.com/users/\(username)") else {
            logger.error("Error in making CodeChef url")
            throw URLError(.badURL)
        }

        do {
            let data = try await downloadDataWithAsyncAwait(url: url)

            let rawHTML = String(decoding: data, as: UTF8.self)
            let parsedHTML = try SwiftSoup.parse(rawHTML)

            let stringHTML = try parsedHTML.outerHtml()

            let finalDataString = getUserDataFromParsedHTML(stringHTML: stringHTML)

            let allContests = try JSONDecoder().decode([CodeChefScrapingContestDTO].self, from: finalDataString.data(using: .utf8)!)

            return allContests

        } catch {
            logger.error("error in downloading CodeChef profile async await: \(error)")
            throw error
        }
    }
}
