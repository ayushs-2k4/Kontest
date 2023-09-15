//
//  KontestApp.swift
//  Kontest
//
//  Created by Ayush Singhal on 12/08/23.
//

import SwiftUI

@main
struct KontestApp: App {
    @State private var allKontestsViewModel = AllKontestsViewModel.instance
    @State private var router = Router.instance
    @State private var errorState = ErrorState()

    let networkMonitor = NetworkMonitor.shared

    @AppStorage("shouldFetchAllEventsFromCalendar") var shouldFetchAllEventsFromCalendar: Bool = false

    init() {
        networkMonitor.start()
    }

    var body: some Scene {
        WindowGroup {
            AllKontestsScreen()
                .environment(allKontestsViewModel)
                .environment(router)
                .environment(networkMonitor)
                .environment(errorState)
                .sheet(item: $errorState.errorWrapper) { errorWrapper in
                    ErrorView(errorWrapper: errorWrapper)
                }
        }
        .commands {
            MyMenu(router: $router)
        }
    }
}
