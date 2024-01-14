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

            if let error = signInEmailViewModel.error {
                withAnimation {
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
                        print("Error in signin out: \(error)")
                    }
                }

                Button {
                    router.popupLastScreen()
                    router.appendScreen(screen: Screen.SettingsScreenType(.AuthenticationScreenType(.SignUpScreen)))
                } label: {
                    Text("Sign Up Instead")
                }

                Button {
                    signInEmailViewModel.error = nil

                    if !isPasswordFieldVisible {
                        withAnimation {
                            if checkIfEmailIsCorrect(emailAddress: signInEmailViewModel.email) {
                                isPasswordFieldVisible = true
                            } else {
                                signInEmailViewModel.error = AppError(title: "Email is not in correct format", description: "")
                            }
                        }
                    } else {
                        Task {
                            let isSignInSuccessful = await signInEmailViewModel.signIn()

                            if isSignInSuccessful {
                                print("Yes, sign in is successful")

                                router.goToRootView()
                            } else {
                                print("No, sign in is not successful")
                            }
                        }
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
