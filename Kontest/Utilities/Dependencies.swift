//
//  Dependencies.swift
//  Kontest
//
//  Created by Ayush Singhal on 18/09/23.
//

import FirebaseCore
import Foundation

final class Dependencies: Sendable {
    let notificationsViewModel: NotificationsViewModel
    let filterWebsitesViewModel: FilterWebsitesViewModel
    let allKontestsViewModel: AllKontestsViewModel
    let changeUsernameViewModel: ChangeUsernameViewModel
    private(set) var leetCodeGraphQLViewModel: LeetCodeGraphQLViewModel
    private(set) var codeChefViewModel: CodeChefViewModel
    private(set) var codeForcesViewModel: CodeForcesViewModel

    static let instance = Dependencies()

    private init() {
        FirebaseApp.configure()

        self.notificationsViewModel = NotificationsViewModel()
        self.filterWebsitesViewModel = FilterWebsitesViewModel()
        self.allKontestsViewModel = AllKontestsViewModel(notificationsViewModel: notificationsViewModel, filterWebsitesViewModel: filterWebsitesViewModel, repository: MultipleRepositories(repositories: [KontestNewAPIRepository(), KontestNewRepository()]))
        self.changeUsernameViewModel = ChangeUsernameViewModel()
        self.leetCodeGraphQLViewModel = LeetCodeGraphQLViewModel(username: changeUsernameViewModel.leetcodeUsername)
        self.codeChefViewModel = CodeChefViewModel(username: changeUsernameViewModel.codeChefUsername)
        self.codeForcesViewModel = CodeForcesViewModel(username: changeUsernameViewModel.codeForcesUsername)
    }

    func changeLeetcodeUsername(leetCodeUsername: String) {
        leetCodeGraphQLViewModel = LeetCodeGraphQLViewModel(username: leetCodeUsername)
    }

    func changeCodeChefUsername(codeChefUsername: String) {
        codeChefViewModel = CodeChefViewModel(username: codeChefUsername)
    }

    func changeCodeForcesUsername(codeForcesUsername: String) {
        codeForcesViewModel = CodeForcesViewModel(username: codeForcesUsername)
    }

    func reloadLeetcodeUsername() {
        leetCodeGraphQLViewModel = LeetCodeGraphQLViewModel(username: changeUsernameViewModel.leetcodeUsername)
    }

    func reloadCodeChefUsername() {
        codeChefViewModel = CodeChefViewModel(username: changeUsernameViewModel.codeChefUsername)
    }

    func reloadCodeForcesUsername() {
        codeForcesViewModel = CodeForcesViewModel(username: changeUsernameViewModel.codeForcesUsername)
    }
}
