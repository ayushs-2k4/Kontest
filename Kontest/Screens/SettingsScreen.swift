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
//            SingleSettingsTileView(title: "Change Usernames") {
//                router.appendScreen(screen: Screen.SettingsScreenType(.ChangeUserNamesScreen))
//            }

            Button("Change Usernames") {
                router.appendScreen(screen: Screen.SettingsScreenType(.ChangeUserNamesScreen))
            }

            Button("Filter Websites") {
                router.appendScreen(screen: Screen.SettingsScreenType(.FilterWebsitesScreen))
            }

//            SingleSettingsTileView(title: "Filter Websites") {
//                router.appendScreen(screen: Screen.SettingsScreenType(.FilterWebsitesScreen))
//            }
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
//            backgroundColor

            Text(title)
        }
        .onTapGesture {
            print("Tapped on: \(title)")
            onTapGesture()
        }
    }
}

#Preview {
    NavigationStack {
        SettingsScreen()
    }
    .environment(ChangeUsernameViewModel.instance)
    .environment(Router.instance)
}

#Preview("SingleSettingsTileView") {
    SingleSettingsTileView(title: "Change Usernames", onTapGesture: {})
}
