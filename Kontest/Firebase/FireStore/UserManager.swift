//
//  UserManager.swift
//  Kontest
//
//  Created by Ayush Singhal on 1/14/24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

struct DBUser {
    let firstName, lastName, email, leetcodeUsername, codeForcesUsername, codeChefUsername: String
    let dateCreated: Date

    init(firstName: String, lastName: String, email: String, leetcodeUsername: String, codeForcesUsername: String, codeChefUsername: String, dateCreated: Date) {
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

    func createNewUser(auth: AuthDataResultModel, firstName: String, lastName: String) {
        let changeUsernameViewModel = Dependencies.instance.changeUsernameViewModel

        let leetcodeUsername: String = changeUsernameViewModel.leetcodeUsername
        let codeForcesUsername: String = changeUsernameViewModel.codeForcesUsername
        let codeChefUsername: String = changeUsernameViewModel.codeChefUsername

        let userData: [String: Any] = [
            "user_id": auth.uid,
            "first_name": firstName,
            "last_name": lastName,
            "email": auth.email ?? "No Email",
            "leetcode_username": leetcodeUsername,
            "code_forces_username": codeForcesUsername,
            "code_chef_username": codeChefUsername,
            "date_created": Timestamp()
        ]

        Firestore.firestore().collection("users").document(auth.uid).setData(userData, merge: true)
    }

    func getUser(userId: String) async throws -> DBUser {
        let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()

        guard let data = snapshot.data() else {
            throw AppError(title: "Can't convert snapshot to dictionary", description: "")
        }

        let firstName = data["first_name"] as? String ?? ""
        let lastName = data["last_name"] as? String ?? ""
        let email = data["email"] as? String ?? ""
        let leetcodeUsername = data["leetcode_username"] as? String ?? ""
        let codeForcesUsername = data["code_forces_username"] as? String ?? ""
        let codeChefUsername = data["code_chef_username"] as? String ?? ""
        let dateCreatedTimestamp = data["date_created"] as? Timestamp
        let dateCreated = dateCreatedTimestamp?.dateValue()

        return DBUser(
            firstName: firstName,
            lastName: lastName,
            email: email,
            leetcodeUsername: leetcodeUsername,
            codeForcesUsername: codeForcesUsername,
            codeChefUsername: codeChefUsername,
            dateCreated: dateCreated ?? .now.addingTimeInterval(-Date().timeIntervalSince1970)
        )
    }
}
