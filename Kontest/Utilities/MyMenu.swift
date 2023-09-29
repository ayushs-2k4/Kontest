//
//  MyMenu.swift
//  Kontest
//
//  Created by Ayush Singhal on 01/09/23.
//

import SwiftUI

struct MyMenu: Commands {
    @Binding var router: Router

    var body: some Commands {
        CommandGroup(after: .appSettings) {
            Button("Settings...") {
                router.appendScreen(screen: .SettingsScreen)
            }
            .keyboardShortcut(KeyEquivalent(","), modifiers: .command)
        }

        CommandGroup(replacing: CommandGroupPlacement.newItem) {}
    }
}
