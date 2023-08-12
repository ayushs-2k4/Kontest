//
//  AllKontestsViewModel.swift
//  Kontests
//
//  Created by Ayush Singhal on 12/08/23.
//

import SwiftUI

@Observable
class AllKontestsViewModel {
    var allContests: [Kontest] = []

    init() {
        Task {
            await getAllContests()
        }
    }

    func getAllContests() async {
        guard let url = URL(string: "https://kontests.net/api/v1/all") else {
            print("Error in making url")
            return
        }

        do {
            let data = try await downloadDataWithAsyncAwait(url: url)
            let allFetchedContests = try JSONDecoder().decode([Kontest].self, from: data)

            await MainActor.run {
                self.allContests = allFetchedContests
            }
        } catch {
            print("error in downloading all Contests async await: \(error)")
        }
    }
}
