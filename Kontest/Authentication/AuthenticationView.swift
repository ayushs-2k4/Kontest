//
//  AuthenticationView.swift
//  Kontest
//
//  Created by Ayush Singhal on 1/14/24.
//

import SwiftUI

struct AuthenticationView: View {
    let signInEmailViewModel: SignInEmailViewModel = .init()

    var body: some View {
        VStack {
            TextField("Email", text: Bindable(signInEmailViewModel).email)

            TextField("Password", text: Bindable(signInEmailViewModel).password)
            
            Button{
                signInEmailViewModel.signIn()
            }label: {
                Text("Sign Up")
            }
        }
    }
}

#Preview {
    AuthenticationView()
        .frame(width: 400, height: 400)
}
