//
//  CollegesRepository.swift
//  Kontest
//
//  Created by Ayush Singhal on 1/16/24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

struct College: Codable, Hashable {
    let name: String
    let domains: [String]
    let webPages: [String]
    let country, alphaTwoCode: String
    let stateProvince: String?

    enum CodingKeys: String, CodingKey {
        case name, domains
        case webPages = "web_pages"
        case country
        case alphaTwoCode = "alpha_two_code"
        case stateProvince = "state-province"
    }
}

class CollegesRepository {
    private init() {}

    static let shared: CollegesRepository = .init()

    private let firestoreEncoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()

        encoder.keyEncodingStrategy = .convertToSnakeCase

        return encoder
    }()

    private let firstoreDecoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()

        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return decoder
    }()

    private func uploadListToFirebase() async {
        let collection = Firestore.firestore().collection("colleges")

        let allColleges = await downloadListViaAPI()
        print("allCollegesCount: \(allColleges.count)")

        var updatedColleges: [College] = []

        for college in allColleges {
            let updatedCollege = College(
                name: college.name,
                domains: college.domains,
                webPages: college.webPages,
                country: college.country,
                alphaTwoCode: college.alphaTwoCode,
                stateProvince: (college.stateProvince?.lowercased() == "jammu" || college.stateProvince?.lowercased() == "kashmir") ? "Jammu and Kashmir" : college.stateProvince
            )

            updatedColleges.append(updatedCollege)
        }

        do {
            for college in updatedColleges {
                try collection.addDocument(from: college)
            }

            print("Done")
        } catch {
            print("Error in uploading colleges: \(error)")
        }
    }

    private func downloadListViaAPI() async -> [College] {
        do {
            let data = try await downloadDataWithAsyncAwait(url: URL(string: "http://universities.hipolabs.com/search?country=India&type=college")!)

            let fetchedColleges = try JSONDecoder().decode([College].self, from: data)

            return fetchedColleges
        } catch {
            print("Error: \(error)")
            return []
        }
    }

    private func getUniqueStateList(colleges: [College]) -> [String] {
        // Extract unique state names using Set
        let uniqueStates = Set(colleges.compactMap { $0.stateProvince })

        // Convert Set back to Array if needed
        let uniqueStatesArray = Array(uniqueStates)

        return uniqueStatesArray
    }

    private func getAllCollegesFromFirestore() async throws -> [College] {
        let collection = Firestore.firestore().collection("colleges")

        let allCollegesFromFirestore = try await collection.getDocuments().documents
        var allColleges: [College] = []

        for college in allCollegesFromFirestore {
            let collegeJSON = try JSONSerialization.data(withJSONObject: college.data())
            let collegeObject = try JSONDecoder().decode(College.self, from: collegeJSON)

            allColleges.append(collegeObject)
        }

        return allColleges
    }

    func getAllCollegesOfAStateFromFirestore(state: String) async throws -> [College] {
        let collection = Firestore.firestore().collection("colleges")

        let allCollegesFromFirestore = try await collection.whereField("state-province", isEqualTo: state).getDocuments().documents
        var allColleges: [College] = []

        for college in allCollegesFromFirestore {
            let collegeJSON = try JSONSerialization.data(withJSONObject: college.data())
            let collegeObject = try JSONDecoder().decode(College.self, from: collegeJSON)

            allColleges.append(collegeObject)
        }

        return allColleges
    }
}
