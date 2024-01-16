//
//  SignUpScreen.swift
//  Kontest
//
//  Created by Ayush Singhal on 1/14/24.
//

import SwiftUI

struct SignUpScreen: View {
    let signInEmailViewModel: AuthenticationEmailViewModel = .shared

    @Environment(Router.self) private var router

    @State private var text: String = ""

    @State private var selectedState: String = "Andhra Pradesh"

    @State private var collegesList: [College] = []
    @State private var selectedCollege: String = "This is a college"

    @FocusState private var focusedField: SignUpTextField?

    @State private var isCollegeListDownloading = false

    var body: some View {
        VStack(alignment: .leading) {
            Text("Get started with your name, email address and password.")
                .bold()
                .padding(.bottom)

            HStack {
                Text("             Name:")

                TextField("first", text: Bindable(signInEmailViewModel).firstName)
                    .focused($focusedField, equals: .firstName)

                TextField("last", text: Bindable(signInEmailViewModel).lastName)
                    .focused($focusedField, equals: .lastName)
            }

            HStack {
                Text("Email address:")

                TextField("name@example.com", text: Bindable(signInEmailViewModel).email)
                    .focused($focusedField, equals: .email)
                #if available
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                #endif
            }
            .padding(.vertical)

            HStack {
                Picker("   Select State:", selection: $selectedState) {
                    ForEach(Constants.states, id: \.self) { state in
                        Text(state)
                    }
                }

                ProgressView()
                    .controlSize(.small)
                    .padding(1)
                    .hidden()
            }
            .onChange(of: selectedState) {
                collegesList.removeAll()

                Task {
                    isCollegeListDownloading = true
                    let downloadedCollegesList = try await CollegesRepository.shared.getAllCollegesOfAStateFromFirestore(state: selectedState)
                        .sorted { college1, college2 in
                            college1.name < college2.name
                        }

                    self.collegesList.append(contentsOf: downloadedCollegesList)

                    isCollegeListDownloading = false

                    selectedCollege = downloadedCollegesList[0].name
                }
            }
            .onAppear(perform: {
                Task {
                    isCollegeListDownloading = true
                    let downloadedCollegesList = try await CollegesRepository.shared.getAllCollegesOfAStateFromFirestore(state: selectedState)
                        .sorted { college1, college2 in
                            college1.name < college2.name
                        }

                    self.collegesList.append(contentsOf: downloadedCollegesList)

                    isCollegeListDownloading = false

                    selectedCollege = downloadedCollegesList[0].name
                }
            })

            HStack {
                Picker("Select College:", selection: $selectedCollege) {
                    ForEach(collegesList.map { clg in
                        clg.name
                    }, id: \.self) { college in
                        Text(college)
                    }
                }

                if isCollegeListDownloading {
                    ProgressView()
                        .controlSize(.small)
                        .padding(1)
                } else {
                    ProgressView()
                        .controlSize(.small)
                        .padding(1)
                        .hidden()
                }
            }

            HStack(alignment: .top) {
                Text("       Password:")

                VStack(alignment: .leading) {
                    SecureField("required", text: Bindable(signInEmailViewModel).password)
                        .focused($focusedField, equals: .password)

                    SecureField("verify", text: Bindable(signInEmailViewModel).confirmPassword)
                        .focused($focusedField, equals: .confirmPassword)

                    Text("Your password must be at least 8 characters long and include a number, an uppercase letter and a lowercase letter.")
                }
            }
            .padding(.vertical)

            if let error = signInEmailViewModel.error {
                HStack {
                    Spacer()

                    if let appError = error as? AppError {
                        VStack(alignment: .trailing) {
                            Text(appError.title)
                                .foregroundStyle(.red)
                                .padding(.horizontal)

                            if !appError.description.isEmpty {
                                Text(appError.description)
                                    .font(.caption2)
                                    .foregroundStyle(.red)
                                    .padding(.horizontal)
                            }
                        }
                    } else {
                        Text(error.localizedDescription)
                            .foregroundStyle(.red)
                            .padding(.horizontal)
                    }
                }
            }

            HStack {
                Spacer()

                if signInEmailViewModel.isLoading {
                    ProgressView()
                        .controlSize(.small)
                        .padding(.horizontal, 1)
                }

                Button {
                    signInEmailViewModel.clearPasswordFields()
                    router.popupLastScreen()
                    router.appendScreen(screen: Screen.SettingsScreenType(.AuthenticationScreenType(.SignInScreen)))
                } label: {
                    Text("Sign In Instead")
                }

                Button {
                    signInEmailViewModel.error = nil

                    if signInEmailViewModel.firstName.isEmpty {
                        signInEmailViewModel.error = AppError(title: "First name can not be empty.", description: "")
                    } else if signInEmailViewModel.lastName.isEmpty {
                        signInEmailViewModel.error = AppError(title: "Last name can not be empty.", description: "")
                    } else if signInEmailViewModel.email.isEmpty {
                        signInEmailViewModel.error = AppError(title: "Email can not be empty.", description: "")
                    } else if !checkIfEmailIsCorrect(emailAddress: signInEmailViewModel.email) {
                        signInEmailViewModel.error = AppError(title: "Email is not in correct format.", description: "")
                    } else if signInEmailViewModel.password.isEmpty {
                        signInEmailViewModel.error = AppError(title: "Password can not be empty.", description: "")
                    } else if !checkIfPasswordIsCorrect(password: signInEmailViewModel.password) {
                        signInEmailViewModel.error = AppError(title: "Password not complying with requirements.", description: "")
                    } else if signInEmailViewModel.password != signInEmailViewModel.confirmPassword {
                        signInEmailViewModel.error = AppError(title: "The passwords you entered do not match.", description: "")
                    } else {
                        Task {
                            let isSignUpSuccessful = await signInEmailViewModel.signUp()

                            if isSignUpSuccessful {
                                print("Yes, sign up is successful")

                                router.goToRootView()

                                signInEmailViewModel.clearAllFields()
                            } else {
                                print("No, sign up is not successful")
                            }
                        }
                    }
                } label: {
                    Text("Sign Up")
                }
                .buttonStyle(.borderedProminent)
                .tint(.accent)
                .disabled(false)
                .keyboardShortcut(.return, modifiers: [])
            }
        }
        #if os(macOS)
        .frame(maxWidth: 400)
        #endif
        .padding()
        .onAppear {
            self.focusedField = .firstName
        }
        .onChange(of: focusedField) { oldValue, newValue in
            print("Focus Changed from \(String(describing: oldValue)) to \(String(describing: newValue))")
        }
    }
}

enum SignUpTextField {
    case firstName
    case lastName
    case email
    case password
    case confirmPassword
}

#Preview {
    SignUpScreen()
        .environment(Router.instance)
        .frame(width: 400, height: 400)
}
