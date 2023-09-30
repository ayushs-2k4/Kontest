//
//  MyMenu.swift
//  Kontest
//
//  Created by Ayush Singhal on 01/09/23.
//

import SwiftUI

struct MyMenu: Commands {
    @Binding var router: Router
    @Binding var panelSelection: Panel?
    let networkMonitor = NetworkMonitor.shared

    var body: some Commands {
        CommandGroup(after: .appSettings) {
            Button("Settings...") {
                if networkMonitor.currentStatus == .satisfied {
                    if panelSelection != .AllKontestScreen {
                        panelSelection = .AllKontestScreen
                    }
                    router.appendScreen(screen: .SettingsScreen)
                }
            }
            .keyboardShortcut(KeyEquivalent(","), modifiers: .command)
        }

        CommandGroup(replacing: CommandGroupPlacement.newItem) {}

        SidebarCommands()
    }
}
