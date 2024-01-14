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

    @Environment(Router.self) private var router

    var body: some View {
        VStack {
            SignInViewTextField(
                leftText: "Email ID:",
                textHint: "Email",
                textBinding: Bindable(signInEmailViewModel).email
            )
            .padding(.horizontal)

            if isPasswordFieldVisible {
                SignInViewTextField(
                    leftText: "Pasword:",
                    textHint: "required",
                    isPasswordType: true,
                    textBinding: Bindable(signInEmailViewModel).password
                )
                .padding(.horizontal)
            }

            HStack {
                Spacer()

                if signInEmailViewModel.isLoading {
                    ProgressView()
                        .controlSize(.small)
                        .padding(.horizontal, 1)
                }

                Button {
                    router.popupLastScreen()
                    router.appendScreen(screen: Screen.SettingsScreenType(.AuthenticationScreenType(.SignUpScreen)))
                } label: {
                    Text("Sign Up Instead")
                }

                Button {
                    if !isPasswordFieldVisible {
                        withAnimation {
                            if checkIfEmailIsCorrect(emailAddress: signInEmailViewModel.email) {
                                isPasswordFieldVisible = true
                            }
                        }
                    } else {
                        signInEmailViewModel.signIn()
                    }
                } label: {
                    Text("Continue")
                }
                .buttonStyle(.borderedProminent)
                .tint(.accent)
            }

            .padding(.horizontal)
        }
        #if os(macOS)
        .frame(maxWidth: 400)
        #endif
    }
}

private func checkIfEmailIsCorrect(emailAddress: String) -> Bool {
    let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailPredicate.evaluate(with: emailAddress)
}

private struct SignInViewTextField: View {
    let leftText: String
    let textHint: String
    var isPasswordType: Bool = false
    @Binding var textBinding: String

    var body: some View {
        HStack {
            Text(leftText)

            if isPasswordType {
                SecureField(textHint, text: $textBinding)
                    .multilineTextAlignment(.trailing)
                    .textFieldStyle(.plain)
            } else {
                TextField(textHint, text: $textBinding)
                    .multilineTextAlignment(.trailing)
                    .textFieldStyle(.plain)
            }
        }
        .padding(10)
        .overlay( // apply a rounded border
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color(.systemGray), lineWidth: 1)
        )
    }
}

#Preview {
    SignInView()
        .environment(Router.instance)
        .frame(width: 500, height: 500)
}
