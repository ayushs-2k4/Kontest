//
//  SignUpScreen.swift
//  Kontest
//
//  Created by Ayush Singhal on 1/14/24.
//

import SwiftUI

struct SignUpScreen: View {
    let signInEmailViewModel: SignInEmailViewModel = .shared

    @Environment(Router.self) private var router

    @State private var text: String = ""

    @FocusState private var focusedField: SignUpTextField?

    var body: some View {
        VStack(alignment: .leading) {
            Text("Get started with your name, email address and password.")
                .bold()
                .padding(.bottom)

            HStack {
                Text("             Name:")

                TextField("first", text: Bindable(signInEmailViewModel).firstName)
                    .focused($focusedField, equals: .firstName)

                TextField("last", text: Bindable(signInEmailViewModel).lastName)
                    .focused($focusedField, equals: .lastName)
            }

            HStack {
                Text("Email address:")

                TextField("name@example.com", text: Bindable(signInEmailViewModel).email)
                    .focused($focusedField, equals: .email)
                #if available
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                #endif
            }
            .padding(.vertical)

            HStack(alignment: .top) {
                Text("       Password:")

                VStack(alignment: .leading) {
                    SecureField("required", text: Bindable(signInEmailViewModel).password)
                        .focused($focusedField, equals: .password)

                    SecureField("verify", text: Bindable(signInEmailViewModel).confirmPassword)
                        .focused($focusedField, equals: .confirmPassword)

                    Text("Your password must be at least 8 characters long and include a number, an uppercase letter and a lowercase letter.")
                }
            }
            .padding(.vertical)

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

                Button {
                    signInEmailViewModel.clearPasswordFields()
                    router.popupLastScreen()
                    router.appendScreen(screen: Screen.SettingsScreenType(.AuthenticationScreenType(.SignInScreen)))
                } label: {
                    Text("Sign In Instead")
                }

//                Button {
//                    router.popupLastScreen()
//                } label: {
//                    Text("Cancel")
//                }

                Button {
                    signInEmailViewModel.error = nil

                    if signInEmailViewModel.firstName.isEmpty {
                        signInEmailViewModel.error = AppError(title: "First name can not be empty.", description: "")
                    } else if signInEmailViewModel.lastName.isEmpty {
                        signInEmailViewModel.error = AppError(title: "Last name can not be empty.", description: "")
                    } else if signInEmailViewModel.email.isEmpty {
                        signInEmailViewModel.error = AppError(title: "Email can not be empty.", description: "")
                    } else if !checkIfEmailIsCorrect(emailAddress: signInEmailViewModel.email) {
                        signInEmailViewModel.error = AppError(title: "Email is not in correct format.", description: "")
                    } else if signInEmailViewModel.password.isEmpty {
                        signInEmailViewModel.error = AppError(title: "Password can not be empty.", description: "")
                    } else if !checkIfPasswordIsCorrect(password: signInEmailViewModel.password) {
                        signInEmailViewModel.error = AppError(title: "Password not complying with requirements.", description: "")
                    } else if signInEmailViewModel.password != signInEmailViewModel.confirmPassword {
                        signInEmailViewModel.error = AppError(title: "The passwords you entered do not match.", description: "")
                    } else {
                        Task {
                            let isSignUpSuccessful = await signInEmailViewModel.signUp()

                            if isSignUpSuccessful {
                                print("Yes, sign up is successful")

                                router.goToRootView()

                                signInEmailViewModel.clearAllFields()
                            } else {
                                print("No, sign up is not successful")
                            }
                        }
                    }
                } label: {
                    Text("Sign Up")
                }
                .buttonStyle(.borderedProminent)
                .tint(.accent)
                .disabled(false)
                .keyboardShortcut(.return, modifiers: [])
            }
        }
        .onAppear {
            self.focusedField = .firstName
        }
        .onChange(of: focusedField) { oldValue, newValue in
            print("Focus Changed from \(oldValue) to \(newValue)")
        }
        #if os(macOS)
        .frame(maxWidth: 400)
        #endif
        .padding()
    }
}

enum SignUpTextField {
    case firstName
    case lastName
    case email
    case password
    case confirmPassword
}

#Preview {
    SignUpScreen()
        .environment(Router.instance)
        .frame(width: 400, height: 400)
}
