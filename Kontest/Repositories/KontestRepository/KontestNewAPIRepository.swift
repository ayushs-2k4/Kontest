//
//  KontestNewAPIRepository.swift
//  Kontest
//
//  Created by Ayush Singhal on 8/1/24.
//

@preconcurrency import FirebaseFirestore
import Foundation
import OSLog

private struct APIType: Codable {
    let htmlPath: String
    let jsonPath: String
    let url: String
}

final class KontestNewAPIRepository: KontestFetcher {
    private let logger = Logger(subsystem: "com.ayushsinghal.Kontest", category: "KontestNewAPIRepository")

    private let firestoreEncoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()

        encoder.keyEncodingStrategy = .convertToSnakeCase

        return encoder
    }()

    private let firestoreDecoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()

        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return decoder
    }()

    func getAllKontests() async throws -> [KontestDTO] {
        let assetsCollection = Firestore.firestore().collection("assets")

        do {
            // Fetch the Firestore document
            let apiDocument = try await assetsCollection.document("api").getDocument(as: APIType.self, decoder: firestoreDecoder)
            logger.info("apiDocument: \("\(apiDocument)")")

            // Ensure URL is valid
            let cloudflareURLString = apiDocument.url
            
            let version = "v1"
            let page = 1
            let perPage = 10000
            
            guard let cloudflareURL = URL(string: cloudflareURLString) else { throw URLError(.badURL) } // Handle invalid URL error
//            guard let cloudflareURL = URL(string: "http://localhost:5151") else { throw URLError(.badURL) } // Handle invalid URL error
 
            // Append path to the URL
            let endpointURL = cloudflareURL
                .appendingPathComponent("api")
                .appendingPathComponent(version)
                .appendingPathComponent("get_kontests")
                .appending(queryItems: [
                    .init(name: "page", value: String(page)),
                    .init(name: "per_page", value: String(perPage))
                ])

            // Download data from the URL
            let data = try await downloadDataWithAsyncAwait(url: endpointURL)
//            logger.info("data: \(String(decoding: data, as: UTF8.self))")

            // Decode the data
            let kontests = try decodeKontests(from: data)
//            logger.info("kontests: \(kontests)")

            return kontests

        } catch {
            logger.error("Error fetching document or data: \(error)")
            throw error
        }
    }

    private func decodeKontests(from data: Data) throws -> [KontestDTO] {
        // Create a JSONDecoder instance
        let decoder = JSONDecoder()

        // Decode the raw JSON data into an array of dictionaries
        let rawKontests = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] ?? []

        // Map "location" to "site" and convert the dictionary to Data
        let modifiedKontests = rawKontests.map { dict -> [String: Any] in
            var mutableDict = dict
            if let location = mutableDict["location"] {
                mutableDict["site"] = location
                mutableDict.removeValue(forKey: "location")
            }
            return mutableDict
        }

        // Convert the modified dictionaries to Data
        let modifiedData = try JSONSerialization.data(withJSONObject: modifiedKontests, options: [])

        // Decode the modified Data into an array of KontestDTO
        let kontests = try decoder.decode([KontestDTO].self, from: modifiedData)

        return kontests
    }
}
