//
//  AuthenticationView.swift
//  Kontest
//
//  Created by Ayush Singhal on 1/14/24.
//

import SwiftUI

struct AuthenticationView: View {
    let signInEmailViewModel: SignInEmailViewModel = .init()

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
            }
            .padding(.vertical)

            HStack(alignment: .top) {
                Text("       Password:")

                VStack(alignment: .leading) {
                    TextField("required", text: Bindable(signInEmailViewModel).password)

                    TextField("verify", text: Bindable(signInEmailViewModel).confirmPassword)

                    Text("Your password must be at least 8 characters long and include a number, an uppercase letter and a lowercase letter.")
                }
            }
            .padding(.vertical)

            HStack {
                Spacer()
                
                Button{
                    
                }label: {
                    Text("Cancel")
                }

                Button {
                    signInEmailViewModel.signIn()
                } label: {
                    Text("Sign Up")
                }
                .disabled(true)
            }
        }
        .padding()
    }
}

#Preview {
    AuthenticationView()
        .frame(width: 400, height: 400)
}
