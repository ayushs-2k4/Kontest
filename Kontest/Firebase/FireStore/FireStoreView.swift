//
//  FireStoreView.swift
//  Kontest
//
//  Created by Ayush Singhal on 1/14/24.
//

import SwiftUI

struct FireStoreView: View {
    let userManager = UserManager.shared
    let authManager = AuthenticationManager.shared

    @State private var dbUSer: DBUser? = nil

    var body: some View {
        Button {
            Task {
                do {
                    let user = try authManager.getAuthenticatedUser()

                    dbUSer = try await userManager.getUser(userId: user.uid)
                } catch {
                    print("Error in  fetching user")
                }
            }
        } label: {
            Text("Get Document")
        }

        if let dbUSer {
            Text(dbUSer.name)
            Text(dbUSer.email)
            Text("\(dbUSer.dateCreated)")
            Text(dbUSer.clg)
        }
    }
}

#Preview {
    FireStoreView()
        .frame(width: 500, height: 500)
}
