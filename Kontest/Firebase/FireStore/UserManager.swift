//
//  UserManager.swift
//  Kontest
//
//  Created by Ayush Singhal on 1/14/24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

struct DBUser: Codable {
    let userId, firstName, lastName, email, leetcodeUsername, codeForcesUsername, codeChefUsername: String
    let dateCreated: Date

    init(userId: String, firstName: String, lastName: String, email: String, leetcodeUsername: String, codeForcesUsername: String, codeChefUsername: String, dateCreated: Date) {
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.leetcodeUsername = leetcodeUsername
        self.codeForcesUsername = codeForcesUsername
        self.codeChefUsername = codeChefUsername
        self.dateCreated = dateCreated
    }
}

final class UserManager {
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

    func createNewUser(auth: AuthDataResultModel, firstName: String, lastName: String) throws {
        let changeUsernameViewModel = Dependencies.instance.changeUsernameViewModel

        let leetcodeUsername: String = changeUsernameViewModel.leetcodeUsername
        let codeForcesUsername: String = changeUsernameViewModel.codeForcesUsername
        let codeChefUsername: String = changeUsernameViewModel.codeChefUsername

        try createNewUser(
            user: DBUser(
                userId: auth.uid,
                firstName: firstName,
                lastName: lastName,
                email: auth.email ?? "No Email",
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
}
