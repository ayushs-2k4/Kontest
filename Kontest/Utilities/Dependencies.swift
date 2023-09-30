//
//  Dependencies.swift
//  Kontest
//
//  Created by Ayush Singhal on 18/09/23.
//

import Foundation

class Dependencies {
    let notificationsViewModel: NotificationsViewModel
    let filterWebsitesViewModel: FilterWebsitesViewModel
    let allKontestsViewModel: AllKontestsViewModel
    let changeUsernameViewModel: ChangeUsernameViewModel
    private(set) var leetCodeGraphQLViewModel: LeetCodeGraphQLViewModel

    static let instance = Dependencies()

    private init() {
        self.notificationsViewModel = NotificationsViewModel()
        self.filterWebsitesViewModel = FilterWebsitesViewModel()
        self.allKontestsViewModel = AllKontestsViewModel(notificationsViewModel: notificationsViewModel, filterWebsitesViewModel: filterWebsitesViewModel, repository: KontestRepository())
        self.changeUsernameViewModel = ChangeUsernameViewModel()
        self.leetCodeGraphQLViewModel = LeetCodeGraphQLViewModel(username: changeUsernameViewModel.leetcodeUsername)
    }

    func changeLeetcodeUsername(leetCodeUsername: String) {
        leetCodeGraphQLViewModel = LeetCodeGraphQLViewModel(username: leetCodeUsername)
    }
}
