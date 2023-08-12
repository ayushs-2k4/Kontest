//
//  AllKontestsViewModel.swift
//  Kontests
//
//  Created by Ayush Singhal on 12/08/23.
//

import SwiftUI

@Observable
class AllKontestsViewModel {
    var allKontests: [Kontest] = []

    init() {
        Task {
            await getAllKontests()
        }
    }

    func getAllKontests() async {
        guard let url = URL(string: "https://kontests.net/api/v1/all") else {
            print("Error in making url")
            return
        }

        do {
            let data = try await downloadDataWithAsyncAwait(url: url)
            let allFetchedKontests = try JSONDecoder().decode([Kontest].self, from: data)

            await MainActor.run {
                self.allKontests = allFetchedKontests
            }
        } catch {
            print("error in downloading all Kontests async await: \(error)")
        }
    }
}
