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
    let name, email, clg: String
    let dateCreated: Date
    
    init(name: String, email: String, clg: String, dateCreated: Date) {
        self.name = name
        self.email = email
        self.clg = clg
        self.dateCreated = dateCreated
    }
}

final class UserManager {
    static let shared = UserManager()

    private init() {}

    func createNewUser(auth: AuthDataResultModel) {
        let userData: [String: Any] = [
            "user_id": auth.uid,
            "name": "Ayush Singhal",
            "email": auth.email ?? "No Email",
            "clg": "DTU",
            "date_created": Timestamp()
        ]

        Firestore.firestore().collection("users").document(auth.uid).setData(userData, merge: true)
    }

    func getUser(userId: String) async throws -> DBUser {
        let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()

        guard let data = snapshot.data() else {
            throw AppError(title: "Can't convert snapshot to dictionary", description: "")
        }

        let name = data["name"] as? String
        let email = data["email"] as? String
        let clg = data["clg"] as? String
        let dateCreatedTimestamp = data["date_created"] as? Timestamp
        let dateCreated = dateCreatedTimestamp?.dateValue()
        
        return DBUser(
            name: name!,
            email: email!,
            clg: clg!,
            dateCreated: dateCreated ?? Date().addingTimeInterval(-Date().timeIntervalSince1970)
        )
    }
}
