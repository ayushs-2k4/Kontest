//
//  KontestNewAPIRepository.swift
//  Kontest
//
//  Created by Ayush Singhal on 9/7/24.
//

import Foundation
import KontestGraphQL
import OSLog

private struct APIType: Codable {
    let htmlPath: String
    let jsonPath: String
    let url: String
}

final class KontestNewAPIRepository: Fetcher, KontestFetcher {
    func getData() async throws -> [KontestDTO] {
        return try await getAllKontests()
    }
    
    typealias DataType = KontestDTO
    
    private let logger = Logger(subsystem: "com.ayushsinghal.Kontest", category: "KontestNewAPIRepository")
    
    func getAllKontests() async throws -> [KontestDTO] {
        // Define the query
        let query = KontestsQuery(page: 1, perPage: 1000, sites: [])
        
        // Create an ApolloClient instance
        let apolloClient = await ApolloFactory.getInstance(url: URL(string: Constants.Endpoints.graphqlURL)!).apollo
        
        let kontestDTOs: [KontestDTO] = try await withCheckedThrowingContinuation { continuation in
            apolloClient.fetch(query: query) { result in
                switch result {
                case .success(let graphQLResult):
                    if let kontests = graphQLResult.data?.kontestQuery?.kontests?.kontests {
                        let kontestDTOs: [KontestDTO] = kontests.map { kontest in
                            KontestDTO(
                                name: kontest.name,
                                url: kontest.url,
                                startTime: kontest.startTime,
                                endTime: kontest.endTime,
                                duration: "",
                                site: kontest.location,
                                in_24_hours: "",
                                status: ""
                            )
                        }
                        
                        continuation.resume(returning: kontestDTOs)
                    }
                    else if let errors = graphQLResult.errors {
                        self.logger.error("Kontests fetching failed with errors: \(errors.description)")
                        
                        continuation.resume(throwing: NSError(domain: "GraphQL", code: -1, userInfo: [NSLocalizedDescriptionKey: errors.description]))
                    }
                    else {
                        continuation.resume(throwing: AppError(title: "Data not found", description: "Data not found in KontestsQuery"))
                    }
                    
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
        
        return kontestDTOs
    }
}
