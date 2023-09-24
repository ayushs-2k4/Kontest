//
//  SettingsScreen.swift
//  Kontest
//
//  Created by Ayush Singhal on 16/08/23.
//

import SwiftUI

struct SettingsScreen: View {
    @Environment(Router.self) private var router

    var body: some View {
        HStack {
            VStack {
                Button("Change Usernames") {
                    router.appendScreen(screen: Screen.SettingsScreenType(.ChangeUserNamesScreen))
                }
                .buttonStyle(.bordered)

                Button("Filter Websites") {
                    router.appendScreen(screen: Screen.SettingsScreenType(.FilterWebsitesScreen))
                }
                .buttonStyle(.bordered)
            }
        }
        .navigationTitle("Settings")
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
