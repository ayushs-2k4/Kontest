//
//  CodeChefViewModel.swift
//  Kontest
//
//  Created by Ayush Singhal on 27/08/23.
//

import Foundation

@Observable
class CodeChefViewModel {
    let codeChefAPIRepository = CodeChefAPIRepository()

    var codeChefProfile: CodeChefAPIModel?

    var isLoading = false

    var error: Error?

    init(username: String) {
        self.isLoading = true

        Task {
            await self.getCodeChefProfile(username: username)
            self.isLoading = false
        }
    }

    private func getCodeChefProfile(username: String) async {
        do {
            let fetchedCodeChefProfile = try await codeChefAPIRepository.getUserData(username: username)

            self.codeChefProfile = CodeChefAPIModel.from(codeChefAPIDTO: fetchedCodeChefProfile)
        } catch {
            self.error = error
            print("error in fetching CodeChef Profile: \(error)")
        }
    }
}
