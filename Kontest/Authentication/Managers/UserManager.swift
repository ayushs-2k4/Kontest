//
//  UserManager.swift
//  Kontest
//
//  Created by Ayush Singhal on 1/14/24.
//

@preconcurrency import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation
import OSLog

struct DBUser: Codable {
    let userId, firstName, lastName, email, selectedCollegeState, selectedCollege, leetcodeUsername, codeForcesUsername, codeChefUsername: String
    let dateCreated: Date

    init(userId: String, firstName: String, lastName: String, email: String, selectedCollegeState: String, selectedCollege: String, leetcodeUsername: String, codeForcesUsername: String, codeChefUsername: String, dateCreated: Date) {
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.selectedCollegeState = selectedCollegeState
        self.selectedCollege = selectedCollege
        self.leetcodeUsername = leetcodeUsername
        self.codeForcesUsername = codeForcesUsername
        self.codeChefUsername = codeChefUsername
        self.dateCreated = dateCreated
    }
}

final class UserManager: Sendable {
    private let logger = Logger(subsystem: "com.ayushsinghal.Kontest", category: "UserManager")

    static let shared = UserManager()

    private init() {}

    private let userCollection = Firestore.firestore().collection("users")

    private let firestoreEncoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()

        encoder.keyEncodingStrategy = .convertToSnakeCase

        return encoder
    }()

    private let firstoreDecoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()

        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return decoder
    }()

    private func userDocument(userId: String) -> DocumentReference {
        return userCollection.document(userId)
    }

    func createNewUser(user: DBUser) throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false, encoder: firestoreEncoder)
    }

    func createNewUser(auth: AuthDataResultModel, firstName: String, lastName: String, selectedCollegeState: String, selectedCollege: String) throws {
        let changeUsernameViewModel = Dependencies.instance.changeUsernameViewModel

        let leetcodeUsername: String = changeUsernameViewModel.leetcodeUsername
        let codeForcesUsername: String = changeUsernameViewModel.codeForcesUsername
        let codeChefUsername: String = changeUsernameViewModel.codeChefUsername

        try createNewUser(
            user: DBUser(
                userId: auth.email ?? auth.uid,
                firstName: firstName,
                lastName: lastName,
                email: auth.email ?? "No Email",
                selectedCollegeState: selectedCollegeState,
                selectedCollege: selectedCollege,
                leetcodeUsername: leetcodeUsername,
                codeForcesUsername: codeForcesUsername,
                codeChefUsername: codeChefUsername,
                dateCreated: Date()
            )
        )
    }

    func getUser(userId: String) async throws -> DBUser {
        let snapshot = try await userDocument(userId: userId).getDocument(as: DBUser.self, decoder: firstoreDecoder)

        return snapshot
    }

    func updateUserUsernames(oldLeetcodeUsername: String, newLeetcodeUsername: String, oldCodeForcesUsername: String, newCodeForcesUsername: String, oldCodeChefUsername: String, newCodeChefUsername: String) {
        if AuthenticationManager.shared.isSignedIn() {
            let finalLeetcodeUsername = newLeetcodeUsername == "" ? oldLeetcodeUsername : newLeetcodeUsername
            let finalCodeForcesUsername = newCodeForcesUsername == "" ? oldCodeForcesUsername : newCodeForcesUsername
            let finalCodeChefUsername = newCodeChefUsername == "" ? oldCodeChefUsername : newCodeChefUsername

            do {
                let userId = try AuthenticationManager.shared.getAuthenticatedUser().email ?? AuthenticationManager.shared.getAuthenticatedUser().uid

                userDocument(userId: userId).updateData([
                    "leetcode_username": finalLeetcodeUsername,
                    "code_chef_username": finalCodeChefUsername,
                    "code_forces_username": finalCodeForcesUsername
                ])
            } catch {
                logger.log("Error in updating usernames: \(error)")
            }
        }
    }

    func updateName(firstName: String, lastName: String, completion: @escaping ((any Error)?) -> ()) {
        if AuthenticationManager.shared.isSignedIn() {
            do {
                let userId = try AuthenticationManager.shared.getAuthenticatedUser().email ?? AuthenticationManager.shared.getAuthenticatedUser().uid

                userDocument(userId: userId).updateData([
                    "first_name": firstName,
                    "last_name": lastName
                ]) { error in
                    if let error {
                        print("Error in updating name: \(error)")
                        self.logger.log("Error in updating name: \(error)")
                        completion(error)
                    } else {
                        print("Successfully updated name")
                        completion(nil)
                    }
                }
            } catch {
                logger.log("Error in updating name: \(error)")
                completion(error)
            }
        }
    }

    func updateCollege(collegeStateName: String, collegeName: String, completion: @escaping ((any Error)?) -> ()) {
        if AuthenticationManager.shared.isSignedIn() {
            do {
                let userId = try AuthenticationManager.shared.getAuthenticatedUser().email ?? AuthenticationManager.shared.getAuthenticatedUser().uid

                userDocument(userId: userId).updateData([
                    "selected_college_state": collegeStateName,
                    "selected_college": collegeName
                ]) { error in
                    if let error {
                        print("Error in updating college: \(error)")
                        self.logger.log("Error in updating college: \(error)")
                        completion(error)
                    } else {
                        print("Successfully updated college")
                        completion(nil)
                    }
                }
            } catch {
                logger.log("Error in updating college: \(error)")
                completion(error)
            }
        }
    }
}
