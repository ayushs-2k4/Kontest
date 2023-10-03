//
//  SettingsScreen.swift
//  Kontest
//
//  Created by Ayush Singhal on 16/08/23.
//

import SwiftUI

struct SettingsScreen: View {
    var body: some View {
        #if os(macOS)
        VStack {
            AllSettingsButtonsView()
        }
        .navigationTitle("Settings")
        #else
        List {
            AllSettingsButtonsView()
        }
        .navigationTitle("Settings")
        #endif
    }
}

private struct AllSettingsButtonsView: View {
    @Environment(Router.self) private var router

    var body: some View {
        Button("Change Usernames") {
            router.appendScreen(screen: Screen.SettingsScreenType(.ChangeUserNamesScreen))
        }

        Button("Filter Websites") {
            router.appendScreen(screen: Screen.SettingsScreenType(.FilterWebsitesScreen))
        }

        Button("About Me!") {
            router.appendScreen(screen: Screen.SettingsScreenType(.RotatingMapScreen))
        }
    }
}

struct SingleSettingsTileView: View {
    let title: String
    let backgroundColor: Color = .yellow
    let onTapGesture: () -> ()

    var body: some View {
        ZStack {
            Text(title)
        }
        .onTapGesture {
            onTapGesture()
        }
    }
}

#Preview {
    NavigationStack {
        SettingsScreen()
    }
    .environment(Dependencies.instance.changeUsernameViewModel)
    .environment(Router.instance)
}

#Preview("SingleSettingsTileView") {
    SingleSettingsTileView(title: "Change Usernames", onTapGesture: {})
}
