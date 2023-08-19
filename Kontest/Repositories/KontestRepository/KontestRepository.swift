//
//  KontestRepository.swift
//  Kontest
//
//  Created by Ayush Singhal on 13/08/23.
//

import Foundation

class KontestRepository: KontestFetcher {
    func getAllKontests() async throws -> [KontestDTO] {
        guard let url = URL(string: "https://kontests.net/api/v1/all") else {
            print("Error in making url")
            throw URLError(.badURL)
        }

        do {
            let data = try await downloadDataWithAsyncAwait(url: url)
            let allFetchedKontests = try JSONDecoder().decode([KontestDTO].self, from: data)
            
            return allFetchedKontests
        } catch {
            print("error in downloading all Kontests async await: \(error)")
            throw error
        }
    }
}
