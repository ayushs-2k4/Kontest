//
//  ChangeUserNameScreen.swift
//  Kontest
//
//  Created by Ayush Singhal on 09/09/23.
//

import SwiftUI

struct ChangeUsernameScreen: View {
    var body: some View {
        #if os(macOS)
            VStack {
                MainChangeUsernameView()
            }
        #else
            Form {
                MainChangeUsernameView()
            }
        #endif
    }
}

struct MainChangeUsernameView: View {
    let changeUsernameViewModel = Dependencies.instance.changeUsernameViewModel

    @State private var leetcodeUsername: String = ""
    @State private var codeForcesUsername: String = ""
    @State private var codeChefUsername: String = ""

    @FocusState private var focusedField: SettingsTextField?

    @Environment(\.dismiss) var dismiss

    init() {
        _leetcodeUsername = State(initialValue: changeUsernameViewModel.leetcodeUsername)
        _codeForcesUsername = State(initialValue: changeUsernameViewModel.codeForcesUsername)
        _codeChefUsername = State(initialValue: changeUsernameViewModel.codeChefUsername)
    }

    var body: some View {
        //        TextField("Enter CodeForces Username", text: Bindable(changeUsernameViewModel).codeForcesUsername)
        //        TextField("Enter Leetcode Username", text: Bindable(changeUsernameViewModel).leetcodeUsername)

        SettingsTextFieldView(lightModeImage: .codeForcesLogo,
                              darkModeImage: .codeForcesLogo,
                              title: "Enter CodeForces Username",
                              boundryColor: KontestModel.getColorForIdentifier(siteAbbreviation: "CodeForces"),
                              submitLabel: .next,
                              usernameBinding: $codeForcesUsername,
                              focusedField: _focusedField,
                              currentField: .CodeForces,
                              onPressingNext: {})

        SettingsTextFieldView(lightModeImage: .leetCodeLightLogo,
                              darkModeImage: .leetCodeDarkLogo,
                              title: "Enter LeetCode Username",
                              boundryColor: KontestModel.getColorForIdentifier(
                                  siteAbbreviation: "LeetCode"
                              ),
                              submitLabel: .next,
                              usernameBinding: $leetcodeUsername,
                              focusedField: _focusedField,
                              currentField: .LeetCode,
                              onPressingNext: {})

        SettingsTextFieldView(lightModeImage: .codeChefLogo,
                              darkModeImage: .codeChefLogo,
                              title: "Enter CodeChef Username",
                              boundryColor: KontestModel.getColorForIdentifier(siteAbbreviation: "CodeChef"),
                              submitLabel: .return,
                              usernameBinding: $codeChefUsername,
                              focusedField: _focusedField,
                              currentField: .CodeChef,
                              onPressingNext: {
                                  completeForm()
                              })

        Button("Save") {
            completeForm()
        }
        .keyboardShortcut(.return)
    }

    func completeForm() {
        changeUsernameViewModel.setCodeForcesUsername(newCodeForcesUsername: codeForcesUsername)
        changeUsernameViewModel.setLeetcodeUsername(newLeetcodeUsername: leetcodeUsername)
        changeUsernameViewModel.setCodeChefUsername(newCodeChefUsername: codeChefUsername)

        UserManager.shared.updateUserUsernames(
            leetcodeUsername: changeUsernameViewModel.leetcodeUsername,
            codeForcesUsername: changeUsernameViewModel.codeForcesUsername,
            codeChefUsername: changeUsernameViewModel.codeChefUsername
        )
        dismiss()
    }
}

struct SettingsTextFieldView: View {
    let lightModeImage: ImageResource
    let darkModeImage: ImageResource
    let title: String
    let boundryColor: Color
    let submitLabel: SubmitLabel
    @Binding var usernameBinding: String
    @FocusState private var focusedField: SettingsTextField?
    let currentField: SettingsTextField
    let onPressingNext: () -> ()

    init(
        lightModeImage: ImageResource,
        darkModeImage: ImageResource,
        title: String,
        boundryColor: Color,
        submitLabel: SubmitLabel,
        usernameBinding: Binding<String>,
        focusedField: FocusState<SettingsTextField?>,
        currentField: SettingsTextField,
        onPressingNext: @escaping () -> ()
    ) {
        self.lightModeImage = lightModeImage
        self.darkModeImage = darkModeImage
        self.title = title
        self.boundryColor = boundryColor
        self.submitLabel = submitLabel
        self._usernameBinding = usernameBinding
        self._focusedField = focusedField
        self.currentField = currentField
        self.onPressingNext = onPressingNext
    }

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack {
            Image(colorScheme == .light ? lightModeImage : darkModeImage)
                .resizable()
                .frame(width: 30, height: 30)

            TextField(title, text: $usernameBinding)
                .textFieldStyle(.plain)
                .submitLabel(submitLabel)
                .focused($focusedField, equals: currentField)
            #if os(iOS)
                .textInputAutocapitalization(.never)
            #endif
        }
        .padding(5)
        .overlay( // apply a rounded border
            RoundedRectangle(cornerRadius: 5)
                .stroke(boundryColor, lineWidth: 1)
        )
        #if os(macOS)
        .frame(maxWidth: 400)
        #endif
        .onSubmit {
            onPressingNext()
            switch currentField {
            case .CodeForces:
                focusedField = .LeetCode
            case .LeetCode:
                focusedField = .CodeChef
            case .CodeChef:
                focusedField = nil
            }
        }
    }
}

enum SettingsTextField {
    case CodeForces
    case LeetCode
    case CodeChef
}

#Preview {
    ChangeUsernameScreen()
}
