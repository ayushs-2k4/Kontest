//
//  SignUpView.swift
//  Kontest
//
//  Created by Ayush Singhal on 1/14/24.
//

import SwiftUI

struct SignUpView: View {
    let signInEmailViewModel: SignInEmailViewModel = .shared

    @Environment(Router.self) private var router

    @State private var text: String = ""

    var body: some View {
        VStack(alignment: .leading) {
            Text("Get started with your name, email address and password.")
                .bold()
                .padding(.bottom)

            HStack {
                Text("             Name:")

                TextField("first", text: Bindable(signInEmailViewModel).firstName)

                TextField("last", text: Bindable(signInEmailViewModel).lastName)
            }

            HStack {
                Text("Email address:")

                TextField("name@example.com", text: Bindable(signInEmailViewModel).email)
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

                    SecureField("verify", text: Bindable(signInEmailViewModel).confirmPassword)

                    Text("Your password must be at least 8 characters long and include a number, an uppercase letter and a lowercase letter.")
                }
            }
            .padding(.vertical)

            HStack {
                Spacer()

                Button {
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
                    signInEmailViewModel.signUp()
                } label: {
                    Text("Sign Up")
                }
                .buttonStyle(.borderedProminent)
                .tint(.accent)
                .disabled(false)
            }
        }
        #if os(macOS)
        .frame(maxWidth: 400)
        #endif
        .padding()
    }
}

private func checkIfPasswordIsCorrect(password: String) -> Bool {
    // Check if the password is at least 8 characters long
    guard password.count >= 8 else {
        return false
    }

    // Check if the password contains at least one uppercase letter
    let uppercaseLetterRegex = ".*[A-Z]+.*"
    let uppercaseLetterTest = NSPredicate(format: "SELF MATCHES %@", uppercaseLetterRegex)
    guard uppercaseLetterTest.evaluate(with: password) else {
        return false
    }

    // Check if the password contains at least one lowercase letter
    let lowercaseLetterRegex = ".*[a-z]+.*"
    let lowercaseLetterTest = NSPredicate(format: "SELF MATCHES %@", lowercaseLetterRegex)
    guard lowercaseLetterTest.evaluate(with: password) else {
        return false
    }

    // Check if the password contains at least one digit (number)
    let digitRegex = ".*[0-9]+.*"
    let digitTest = NSPredicate(format: "SELF MATCHES %@", digitRegex)
    guard digitTest.evaluate(with: password) else {
        return false
    }

    // All requirements are met
    return true
}

#Preview {
    SignUpView()
        .environment(Router.instance)
        .frame(width: 400, height: 400)
}
