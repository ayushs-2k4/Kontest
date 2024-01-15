//
//  KontestApp.swift
//  Kontest
//
//  Created by Ayush Singhal on 12/08/23.
//

import Firebase
import OSLog
import SwiftUI

@main
struct KontestApp: App {
    private let logger = Logger(subsystem: "com.ayushsinghal.Kontest", category: "KontestApp")

    init() {
        networkMonitor.start(afterSeconds: 0.5)

//        FirebaseApp.configure() // moved to Dependencies, as they are running first than init, and app is crashing on putting this in init()
//        logger.log("Firebase Configured")
    }

    @State private var allKontestsViewModel = Dependencies.instance.allKontestsViewModel

    @State private var router = Router.instance
    @State private var errorState = ErrorState()
    @State private var panelSelection: Panel? = .AllKontestScreen

    let networkMonitor = NetworkMonitor.shared

    var body: some Scene {
        WindowGroup {
            if let defaults = UserDefaults(suiteName: Constants.userDefaultsGroupID) {
                ContentView(panelSelection: $panelSelection)
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
                #if os(macOS)
                    .frame(minWidth: 900, idealWidth: 1100, minHeight: 500, idealHeight: 600)
                #endif
                    .defaultAppStorage(defaults)
            } else {
                Text("Failed to load user defaults")
            }
        }
        .commands {
            MyMenu(router: $router, panelSelection: $panelSelection)
        }
    }
}

#if os(macOS)
    fileprivate func disallowTabbingMode() {
        NSWindow.allowsAutomaticWindowTabbing = false
    }
#endif
