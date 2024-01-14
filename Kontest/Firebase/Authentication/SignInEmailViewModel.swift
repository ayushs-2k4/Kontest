//
//  SignInEmailViewModel.swift
//  Kontest
//
//  Created by Ayush Singhal on 1/14/24.
//

import Foundation

@Observable
final class SignInEmailViewModel {
    var email = ""
    var password = ""

    func signIn() {
        guard !email.isEmpty,!password.isEmpty else {
            print("No email or password found.")
            return
        }

        Task {
            do {
                let returnedUserData = try await AuthenticationManager.shared.createNewUser(email: email, password: password)
                print("Success in logging in with email - password")
                print("returnedUserData: \(returnedUserData)")
                
                UserManager.shared.createNewUser(auth: returnedUserData)
                
            } catch {
                print("Error in siging in with email - password: \(error)")
            }
        }
    }
}
