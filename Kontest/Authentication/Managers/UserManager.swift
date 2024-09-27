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
        
        // Construct the URL
        let url = URL(string: Constants.Endpoints.userServiceURL)!.appendingPathComponent("user/all-details")
        
        // Create the URL request
        var request = URLRequest(url: url)
        request.httpMethod = "PUT" // Assuming you are using PUT method to update user details
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        
        // Prepare the request body
        var body: [String: Any] = [:]
        
        if let firstName = firstName {
            body["first_name"] = firstName
        }
        if let lastName = lastName {
            body["last_name"] = lastName
        }
        if let selectedCollegeState = selectedCollegeState {
            body["selected_college_state"] = selectedCollegeState
        }
        if let selectedCollege = selectedCollege {
            body["selected_college"] = selectedCollege
        }
        if let leetcodeUsername = leetcodeUsername {
            body["leetcode_username"] = leetcodeUsername
        }
        if let codeForcesUsername = codeForcesUsername {
            body["codeforces_username"] = codeForcesUsername
        }
        if let codeChefUsername = codeChefUsername {
            body["codechef_username"] = codeChefUsername
        }
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        
        // Perform the network request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Ensure the response is successful
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        // Handle the response if needed
        // For example, decode the response if there's any data to process
        let responseData = String(data: data, encoding: .utf8)
        print("User details updated successfully. Response: \(responseData ?? "No response data")")
    }
    
    func getUser() async throws -> DBUser {
        guard let jwtToken = await AuthenticationManager.shared.getJWTToken() else { throw AppError(title: "JWT Token is missing", description: "JWT Token is missing") }
        
        guard let authenticatedUser = await AuthenticationManager.shared.getAuthenticatedUser() else {
            throw AppError(title: "Authenticated user is missing", description: "Authenticated user is missing")
        }
        
        let apolloClient = await ApolloFactory.getInstance(url: URL(string: Constants.Endpoints.graphqlURL)!, customHeaders: ["Authorization": "Bearer \(jwtToken)"]).apollo
        
        let user: DBUser = try await withCheckedThrowingContinuation { continuation in
            let userQuery = UserQuery()
            
            apolloClient.fetch(query: userQuery) { result in
                switch result {
                case .success(let graphQLResult):
                    if let user = graphQLResult.data?.user {
                        let dbUser = DBUser(
                            firstName: user.firstName,
                            lastName: user.lastName,
                            email: authenticatedUser.email,
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
    let firstName, lastName, email, selectedCollegeState, selectedCollege, leetcodeUsername, codeForcesUsername, codeChefUsername: String
    let dateCreated: Date
    
    init(firstName: String, lastName: String, email: String, selectedCollegeState: String, selectedCollege: String, leetcodeUsername: String, codeForcesUsername: String, codeChefUsername: String, dateCreated: Date) {
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
