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
    let networkMonitor = NetworkMonitor.shared
    
    init(){
        networkMonitor.start()
    }

    var body: some Scene {
        WindowGroup {
            AllKontestsScreen()
                .environment(allKontestsViewModel)
                .environment(router)
                .environment(networkMonitor)
        }
        .commands {
            MyMenu(router: $router)
        }
    }
}
