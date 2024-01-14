//
//  SignInEmailViewModel.swift
//  Kontest
//
//  Created by Ayush Singhal on 1/14/24.
//

import FirebaseAuth
import Foundation
import OSLog

@Observable
final class SignInEmailViewModel {
    private let logger = Logger(subsystem: "com.ayushsinghal.Kontest", category: "SignInEmailViewModel")

    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var firstName: String = ""
    var lastName: String = ""

    var isLoading: Bool = false

    var error: Error?

    static let shared = SignInEmailViewModel()

    private init() {}

    func signIn() async -> Bool {
        if email.isEmpty {
            error = AppError(title: "Email cannot empty.", description: "")
            logger.log("Email is empty.")
            return false
        }

        if password.isEmpty {
            error = AppError(title: "Password cannot empty.", description: "")
            logger.log("Password is empty.")
            return false
        }

        isLoading = true

        do {
            let returnedUserData = try await AuthenticationManager.shared.signIn(email: email, password: password)

            print("Success in logging in with email - password")
            print("returnedUserData: \(returnedUserData)")

            isLoading = false
            return true

        } catch {
            let nsError = error as NSError

            if nsError.domain == "FIRAuthErrorDomain" {
                let errorCodeName = nsError.userInfo[AuthErrorUserInfoNameKey] as? String
                let errorCode = AuthErrorCode(_nsError: nsError)

//                if errorCodeName == "ERROR_INVALID_CREDENTIAL" {
//                    self.error = AppError(title: "Password is wrong", description: "") // Gives (this) same errorCodeName in atlease these situations ---> Wrong password, Account not present
//                } else {
                    switch errorCode {
                    case AuthErrorCode.wrongPassword:
                        self.error = AppError(title: "Password is wrong", description: "")

                    case AuthErrorCode.userDisabled:
                        self.error = AppError(title: "Your Account has been disabled", description: "Contact Support - ayushsinghals02@gmail.com")

                    case AuthErrorCode.tooManyRequests:
                        self.error = AppError(title: "Your Account has been temporarily disabled due to multiple wrong attempts", description: "Contact Support - ayushsinghals02@gmail.com")

                    case AuthErrorCode.userNotFound:
                        self.error = AppError(title: "You don't have an account, please Sign up instead!", description: "")

                    default:
                        print(error)
                        self.error = error
                    }
//                }
            }

            print("Error in siging in with email - password: \(error)")

            isLoading = false
            return false
        }
    }

    func signUp() {
        isLoading = true

        guard !email.isEmpty,!password.isEmpty else {
            error = AppError(title: "Email or Password is Empty", description: "")
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

func checkIfEmailIsCorrect(emailAddress: String) -> Bool {
    let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailPredicate.evaluate(with: emailAddress)
}
