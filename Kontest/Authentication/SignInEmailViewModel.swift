//
//  SignInEmailViewModel.swift
//  Kontest
//
//  Created by Ayush Singhal on 1/14/24.
//

import Foundation

@Observable
final class SignInEmailViewModel {
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var firstName: String = ""
    var lastName: String = ""

    var isLoading: Bool = false

    static let shared = SignInEmailViewModel()

    private init() {}

    func signIn() {
        isLoading = true

        guard !email.isEmpty,!password.isEmpty else {
            print("No email or password found.")
            return
        }

        Task {
            do {
                let returnedUserData = try await AuthenticationManager.shared.signIn(email: email, password: password)
                print("Success in logging in with email - password")
                print("returnedUserData: \(returnedUserData)")

            } catch {
                print("Error in siging in with email - password: \(error)")
            }

            isLoading = false
        }
    }

    func signUp() {
        isLoading = true

        guard !email.isEmpty,!password.isEmpty else {
            print("No email or password found.")
            return
        }

        Task {
            do {
                let returnedUserData = try await AuthenticationManager.shared.createNewUser(email: email, password: password)
                print("Success in signing up with email - password")
                print("returnedUserData: \(returnedUserData)")

                UserManager.shared.createNewUser(auth: returnedUserData)

            } catch {
                print("Error in siging up with email - password: \(error)")
            }

            self.isLoading = false
        }
    }
}
