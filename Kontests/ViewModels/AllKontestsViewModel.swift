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
    let repository = KontestRepository()

    init() {
        Task {
            await getAllKontests()
        }
    }

    func getAllKontests() async {
        do {
            let fetchedKontests = try await repository.getAllKontests()

            await MainActor.run {
                self.allKontests = fetchedKontests
            }
        } catch {
            print("error in fetching all Kontests: \(error)")
        }
    }
}
