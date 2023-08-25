//
//  SettingsScreen.swift
//  Kontest
//
//  Created by Ayush Singhal on 16/08/23.
//

import SwiftUI

struct SettingsScreen: View {
    let settingsViewModel = SettingsViewModel.instance

    @State private var leetcodeUsername: String = ""
    @State private var codeForcesUsername: String = ""

    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss

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
                    .textFieldStyle(.plain)
                #if os(iOS)
                    .textInputAutocapitalization(.never)
                #endif
            }
            .padding(5)
            .overlay( // apply a rounded border
                RoundedRectangle(cornerRadius: 5)
                    .stroke(KontestModel.getColorForIdentifier(site: "CodeForces"), lineWidth: 1)
            )
            .frame(maxWidth: 400)

            HStack {
                Image(colorScheme == .light ? .leetCodeDarkLogo : .leetCodeWhiteLogo)
                    .resizable()
                    .frame(width: 30, height: 30)

                TextField("Enter Leetcode Username", text: $leetcodeUsername)
                    .textFieldStyle(.plain)
                #if os(iOS)
                    .textInputAutocapitalization(.never)
                #endif
            }
            .padding(.vertical, 5)
            .overlay( // apply a rounded border
                RoundedRectangle(cornerRadius: 5)
                    .stroke(KontestModel.getColorForIdentifier(site: "LeetCode"), lineWidth: 1)
            )
            .frame(maxWidth: 400)

            Button("Save") {
                settingsViewModel.setCodeForcesUsername(newCodeForcesUsername: codeForcesUsername)
                settingsViewModel.setLeetcodeUsername(newLeetcodeUsername: leetcodeUsername)
                dismiss()
            }
            .keyboardShortcut(.return)
        }
        .padding()
    }
}

#Preview {
    SettingsScreen()
        .environment(SettingsViewModel.instance)
}
