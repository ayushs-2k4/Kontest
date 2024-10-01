//
//  UserManager.swift
//  Kontest
//
//  Created by Ayush Singhal on 1/14/24.
//

import Foundation
import KontestGraphQL
import OSLog

actor UserManager {
    private let logger = Logger(subsystem: "com.ayushsinghal.Kontest", category: "UserManager")
    
    static var shared = UserManager()
    
    private init() {}
    
    func updateUserDetails(
        firstName: String? = nil,
        lastName: String? = nil,
        selectedCollegeState: String? = nil,
        selectedCollege: String? = nil,
        leetcodeUsername: String? = nil,
        codeForcesUsername: String? = nil,
        codeChefUsername: String? = nil
    ) async throws {
        // Retrieve JWT token
        guard let jwtToken = await AuthenticationManager.shared.getJWTToken() else {
            throw AppError(title: "Authentication Error", description: "Unable to retrieve JWT token.")
        }
        
        let apolloClient = await ApolloFactory.getInstance(url: URL(string: Constants.Endpoints.graphqlURL)!, customHeaders: ["Authorization": "Bearer \(jwtToken)"]).apollo
        
        let result: String = try await withCheckedThrowingContinuation { continuation in
            let updateUserMutation = UpdateUserMutation(
                firstName: firstName != nil ? .some(firstName!) : .null,
                lastName: lastName != nil ? .some(lastName!) : .null,
                selectedCollegeState: selectedCollegeState != nil ? .some(selectedCollegeState!) : .null,
                selectedCollege: selectedCollege != nil ? .some(selectedCollege!) : .null,
                leetcodeUsername: leetcodeUsername != nil ? .some(leetcodeUsername!) : .null,
                codechefUsername: codeChefUsername != nil ? .some(codeChefUsername!) : .null,
                codeforcesUsername: codeForcesUsername != nil ? .some(codeForcesUsername!) : .null
            )
            
            apolloClient.perform(mutation: updateUserMutation) { result in
                switch result {
                case .success(let graphQLResult):
                    if let successMessage = graphQLResult.data?.updateUser {
                        continuation.resume(returning: successMessage)
                    } else if let errors = graphQLResult.errors {
                        self.logger.error("Error in updating user: \(errors.description)")
                       
                        continuation.resume(throwing: NSError(domain: "GraphQL", code: -1, userInfo: [NSLocalizedDescriptionKey: errors.description]))
                    } else {
                        self.logger.error("Error in updating user: No data returned from GraphQL")
                        
                        continuation.resume(throwing: AppError(title: "Updating user Failed.", description: "Updating user Failed."))
                    }
                    
                case .failure(let error):
                    print("Network error: \(error)")
                    // Resume with a network error
                    continuation.resume(throwing: error)
                }
            }
        }
        
        logger.info("Result of updating user: \(result)")
    }
    
    func getUser() async throws -> DBUser {
        guard let jwtToken = await AuthenticationManager.shared.getJWTToken() else { throw AppError(title: "JWT Token is missing", description: "JWT Token is missing") }
        
        guard let authenticatedUser = await AuthenticationManager.shared.getAuthenticatedUser() else {
            throw AppError(title: "Authenticated user is missing", description: "Authenticated user is missing")
        }
        
        let apolloClient = await ApolloFactory.getInstance(url: URL(string: Constants.Endpoints.graphqlURL)!, customHeaders: ["Authorization": "Bearer \(jwtToken)"]).apollo
        
        let user: DBUser = try await withCheckedThrowingContinuation { continuation in
            let userQuery = UserQuery()
            
            apolloClient.fetch(query: userQuery, cachePolicy: .fetchIgnoringCacheCompletely) { result in
                switch result {
                case .success(let graphQLResult):
                    if let user = graphQLResult.data?.user {
                        let dbUser = DBUser(
                            firstName: user.firstName,
                            lastName: user.lastName,
                            email: user.email,
                            selectedCollegeState: user.selectedCollegeState ?? "",
                            selectedCollege: user.selectedCollege ?? "",
                            leetcodeUsername: user.leetcodeUsername ?? "",
                            codeForcesUsername: user.codeforcesUsername ?? "",
                            codeChefUsername: user.codechefUsername ?? "",
                            dateCreated: .now
                        )
                        
                        continuation.resume(returning: dbUser)
                    } else if let errors = graphQLResult.errors {
                        self.logger.error("Error in fetching user: \(errors.description)")
                        
                        continuation.resume(throwing: NSError(domain: "GraphQL", code: -1, userInfo: [NSLocalizedDescriptionKey: errors.description]))
                    } else {
                        continuation.resume(throwing: AppError(title: "Fetching user Failed.", description: "Fetching user Failed."))
                    }
                    
                case .failure(let error):
                    print("Network error: \(error)")
                    // Resume with a network error
                    continuation.resume(throwing: error)
                }
            }
        }
        
        return user
    }
}

struct DBUser: Codable {
    let firstName, lastName, selectedCollegeState, selectedCollege, leetcodeUsername, codeForcesUsername, codeChefUsername: String
    let dateCreated: Date
    let email: String?
    
    init(
        firstName: String,
        lastName: String,
        email: String?,
        selectedCollegeState: String,
        selectedCollege: String,
        leetcodeUsername: String,
        codeForcesUsername: String,
        codeChefUsername: String,
        dateCreated: Date
    ) {
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
    
    static let temp = DBUser(
        firstName: "",
        lastName: "",
        email: "",
        selectedCollegeState: "",
        selectedCollege: "",
        leetcodeUsername: "",
        codeForcesUsername: "",
        codeChefUsername: "",
        dateCreated: .now
    )
}
