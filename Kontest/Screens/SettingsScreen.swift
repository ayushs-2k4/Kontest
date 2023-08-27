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
    @State private var codeChefUsername: String = ""

    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss

    init() {
        _leetcodeUsername = State(initialValue: settingsViewModel.leetcodeUsername)
        _codeForcesUsername = State(initialValue: settingsViewModel.codeForcesUsername)
        _codeChefUsername = State(initialValue: settingsViewModel.codeChefUsername)
    }

    var body: some View {
//        TextField("Enter CodeForces Username", text: Bindable(settingsViewModel).codeForcesUsername)
//        TextField("Enter Leetcode Username", text: Bindable(settingsViewModel).leetcodeUsername)

        VStack {
            SettingsTextFieldView(lightModeImage: .codeForcesLogo, darkModeImage: .codeForcesLogo, title: "Enter CodeForces Username", boundryColor: KontestModel.getColorForIdentifier(site: "CodeForces"), usernameBinding: $codeForcesUsername)

            SettingsTextFieldView(lightModeImage: .leetCodeDarkLogo, darkModeImage: .leetCodeWhiteLogo, title: "Enter LeetCode Username", boundryColor: KontestModel.getColorForIdentifier(site: "LeetCode"), usernameBinding: $leetcodeUsername)
            
            SettingsTextFieldView(lightModeImage: .codeChefLogo, darkModeImage: .codeChefLogo, title: "Enter CodeChef Username", boundryColor: KontestModel.getColorForIdentifier(site: "CodeChef"), usernameBinding: $codeChefUsername)

            Button("Save") {
                settingsViewModel.setCodeForcesUsername(newCodeForcesUsername: codeForcesUsername)
                settingsViewModel.setLeetcodeUsername(newLeetcodeUsername: leetcodeUsername)
                settingsViewModel.setCodeChefUsername(newCodeChefUsername: codeChefUsername)
                dismiss()
            }
            .keyboardShortcut(.return)
        }
        .padding()
    }
}

struct SettingsTextFieldView: View {
    let lightModeImage: ImageResource
    let darkModeImage: ImageResource
    let title: String
    let boundryColor: Color
    @Binding var usernameBinding: String
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack {
            Image(colorScheme == .light ? lightModeImage : darkModeImage)
                .resizable()
                .frame(width: 30, height: 30)

            TextField(title, text: $usernameBinding)
                .textFieldStyle(.plain)
            #if os(iOS)
                .textInputAutocapitalization(.never)
            #endif
        }
        .padding(5)
        .overlay( // apply a rounded border
            RoundedRectangle(cornerRadius: 5)
                .stroke(boundryColor, lineWidth: 1)
        )
        .frame(maxWidth: 400)
    }
}

#Preview {
    SettingsScreen()
        .environment(SettingsViewModel.instance)
}
