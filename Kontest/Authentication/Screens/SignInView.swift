//
//  SignInView.swift
//  Kontest
//
//  Created by Ayush Singhal on 1/15/24.
//

import SwiftUI

struct SignInView: View {
    let signInEmailViewModel: SignInEmailViewModel = .shared

    @State private var isPasswordFieldVisible: Bool = false

    @FocusState private var focusedField: SignInTextField?

    @Environment(Router.self) private var router

    var body: some View {
        VStack {
            SignInViewTextField(
                leftText: "Email ID:",
                textHint: "Email",
                isPasswordType: false,
                focusedField: _focusedField,
                currentField: .email,
                textBinding: Bindable(signInEmailViewModel).email
            )
            .padding(.horizontal)

            if isPasswordFieldVisible {
                SignInViewTextField(
                    leftText: "Pasword:",
                    textHint: "required",
                    isPasswordType: true,
                    focusedField: _focusedField,
                    currentField: .password,
                    textBinding: Bindable(signInEmailViewModel).password
                )
                .padding(.horizontal)
            }

            if let error = signInEmailViewModel.error {
                HStack {
                    Spacer()

                    if let appError = error as? AppError {
                        VStack(alignment: .trailing) {
                            Text(appError.title)
                                .foregroundStyle(.red)
                                .padding(.horizontal)

                            if !appError.description.isEmpty {
                                Text(appError.description)
                                    .font(.caption2)
                                    .foregroundStyle(.red)
                                    .padding(.horizontal)
                            }
                        }
                    } else {
                        Text(error.localizedDescription)
                            .foregroundStyle(.red)
                            .padding(.horizontal)
                    }
                }
            }

            HStack {
                Spacer()

                if signInEmailViewModel.isLoading {
                    ProgressView()
                        .controlSize(.small)
                        .padding(.horizontal, 1)
                }

                Button("Sign Out") {
                    do {
                        try AuthenticationManager.shared.signOut()
                        print("Successfully signed out")
                    } catch {
                        signInEmailViewModel.error = AppError(title: "Error in Signing out", description: error.localizedDescription)
                        print("Error in signin out: \(error)")
                    }
                }

                Button {
                    router.popupLastScreen()
                    router.appendScreen(screen: Screen.SettingsScreenType(.AuthenticationScreenType(.SignUpScreen)))
                } label: {
                    Text("Sign Up Instead")
                }

                Button("Continue") {
                    signInEmailViewModel.error = nil

                    if !isPasswordFieldVisible {
                        if checkIfEmailIsCorrect(emailAddress: signInEmailViewModel.email) {
                            isPasswordFieldVisible = true

                            self.focusedField = .password
                        } else {
                            signInEmailViewModel.error = AppError(title: "Email is not in correct format", description: "")
                        }
                    } else {
                        Task {
                            let isSignInSuccessful = await signInEmailViewModel.signIn()

                            if isSignInSuccessful {
                                print("Yes, sign in is successful")

                                router.goToRootView()

                                signInEmailViewModel.clearAllFields()
                            } else {
                                print("No, sign in is not successful")
                            }
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.accent)
                .keyboardShortcut(.return, modifiers: [])
            }

            .padding(.horizontal)
        }
        .onAppear {
            self.focusedField = .email
        }
        #if os(macOS)
        .frame(maxWidth: 400)
        #endif
    }
}

private struct SignInViewTextField: View {
    let leftText: String
    let textHint: String
    var isPasswordType: Bool = false
    @FocusState private var focusedField: SignInTextField?
    let currentField: SignInTextField
    @Binding var textBinding: String

    init(
        leftText: String,
        textHint: String,
        isPasswordType: Bool,
        focusedField: FocusState<SignInTextField?>,
        currentField: SignInTextField,
        textBinding: Binding<String>
    ) {
        self.leftText = leftText
        self.textHint = textHint
        self.isPasswordType = isPasswordType
        self._focusedField = focusedField
        self.currentField = currentField
        self._textBinding = textBinding
    }

    var body: some View {
        HStack {
            Text(leftText)

            if isPasswordType {
                SecureField(textHint, text: $textBinding)
                    .multilineTextAlignment(.trailing)
                    .textFieldStyle(.plain)
                    .focused($focusedField, equals: currentField)
            } else {
                TextField(textHint, text: $textBinding)
                    .multilineTextAlignment(.trailing)
                    .textFieldStyle(.plain)
                    .focused($focusedField, equals: currentField)
            }
        }
        .padding(10)
        .overlay( // apply a rounded border
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color(.systemGray), lineWidth: 1)
        )
    }
}

enum SignInTextField {
    case email
    case password
}

#Preview {
    SignInView()
        .environment(Router.instance)
        .frame(width: 500, height: 500)
}
