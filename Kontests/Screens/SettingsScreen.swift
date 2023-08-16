//
//  SettingsScreen.swift
//  Kontests
//
//  Created by Ayush Singhal on 16/08/23.
//

import SwiftUI

struct SettingsScreen: View {
    let settingsViewModel = SettingsViewModel.instance

    @State private var leetcodeUsername: String = ""
    @State private var codeForcesUsername: String = ""

    @Environment(\.colorScheme) var colorScheme

    init() {
        _leetcodeUsername = State(initialValue: settingsViewModel.leetcodeUsername)
        _codeForcesUsername = State(initialValue: settingsViewModel.codeForcesUsername)
    }

    var body: some View {
//        TextField("Enter CodeForces Username", text: Bindable(settingsViewModel).codeForcesUsername)
//        TextField("Enter Leetcode Username", text: Bindable(settingsViewModel).leetcodeUsername)

        VStack {
            HStack {
                Image(.codeForcesLogo)
                    .resizable()
                    .frame(width: 30, height: 30)

                TextField("Enter CodeForces Username", text: $codeForcesUsername)
                    .textFieldStyle(.roundedBorder)
                #if os(iOS)
                    .textInputAutocapitalization(.never)
                #endif
            }

            HStack {
                Image(colorScheme == .light ? .leetCodeDarkLogo : .leetCodeWhiteLogo)
                    .resizable()
                    .frame(width: 30, height: 30)

                TextField("Enter Leetcode Username", text: $leetcodeUsername)
                    .textFieldStyle(.roundedBorder)
                #if os(iOS)
                    .textInputAutocapitalization(.never)
                #endif
            }

            Button("Save") {
                settingsViewModel.setCodeForcesUsername(newCodeForcesUsername: codeForcesUsername)
                settingsViewModel.setLeetcodeUsername(newLeetcodeUsername: leetcodeUsername)
            }
        }
    }
}

#Preview {
    SettingsScreen()
        .environment(SettingsViewModel.instance)
}
