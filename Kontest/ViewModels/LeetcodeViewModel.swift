//
//  LeetcodeViewModel.swift
//  Kontest
//
//  Created by Ayush Singhal on 16/08/23.
//

import SwiftUI

@Observable
class LeetcodeViewModel {
    let leetcodeAPIRepository = LeetcodeAPIRepository()

    var leetcodeProfile: LeetcodeAPIModel?

    var isLoading = false

    var error: Error?
    var status: String?

    init(username: String) {
        self.isLoading = true
        Task {
            await self.getLeetcodeProfile(username: username)
            self.isLoading = false
            self.status = self.leetcodeProfile?.status
        }
    }

    private func getLeetcodeProfile(username: String) async {
        do {
            let fetchedLeetcodeProfile = try await leetcodeAPIRepository.getUserData(username: username)

            self.leetcodeProfile = LeetcodeAPIModel.from(dto: fetchedLeetcodeProfile)

        } catch {
            self.error = error
            print("error in fetching Leetcode Profile: \(error)")
        }
    }
}
