//
//  KontestApp.swift
//  Kontest
//
//  Created by Ayush Singhal on 12/08/23.
//

import SwiftUI

@main
struct KontestApp: App {
    @State private var allKontestsViewModel = Dependencies.instance.allKontestsViewModel

    @State private var router = Router.instance
    @State private var errorState = ErrorState()

    let networkMonitor = NetworkMonitor.shared

    @AppStorage("shouldFetchAllEventsFromCalendar", store: UserDefaults(suiteName: Constants.userDefaultsGroupID)) var shouldFetchAllEventsFromCalendar: Bool = false

    init() {
        networkMonitor.start()
    }

    var body: some Scene {
        WindowGroup {
            if let defaults = UserDefaults(suiteName: Constants.userDefaultsGroupID) {
                AllKontestsScreen()
                    .environment(allKontestsViewModel)
                    .environment(router)
                    .environment(networkMonitor)
                    .environment(errorState)
                    .sheet(item: $errorState.errorWrapper) { errorWrapper in
                        ErrorView(errorWrapper: errorWrapper)
                        #if os(macOS)
                            .fixedSize()
                        #endif
                    }
                    .onAppear(perform: {
                        #if os(macOS)
                            disallowTabbingMode()
                        #endif
                    })
                    .defaultAppStorage(defaults)
            } else {
                Text("Failed to load user defaults")
            }
        }
        .commands {
            MyMenu(router: $router)
        }
    }
}

#if os(macOS)
    fileprivate func disallowTabbingMode() {
        NSWindow.allowsAutomaticWindowTabbing = false
    }
#endif
