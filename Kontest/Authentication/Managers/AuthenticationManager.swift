//
//  AuthenticationManager.swift
//  Kontest
//
//  Created by Ayush Singhal on 1/14/24.
//

import FirebaseAuth
import Foundation

import ApolloAPI
import Foundation
import KontestGraphQL
import OSLog

public struct LoginResponse: Decodable, Sendable {
    let email: String
    let jwtToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case email = "username"
        case jwtToken
        case refreshToken
    }
}

struct SignupResponse: Decodable {
    let email: String
    let jwtToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case email = "username"
        case jwtToken
        case refreshToken
    }
}

struct NetworkError: Error {
    let title: String
    let description: String
    let code: Int
}

actor AuthenticationManager: Sendable {
    private let logger = Logger(subsystem: "com.ayushsinghal.Kontest", category: "AuthenticationManager")
    
    static let shared = AuthenticationManager()
    
    private(set) static var isAuthenticated: Bool = false
    
    private init() {
        Task {
            AuthenticationManager.isAuthenticated = await self.checkAuthenticationStatus()
        }
    }
    
    func handleError(for statusCode: Int) -> any Error {
        switch statusCode {
        case 401:
            logger.error("Authentication Failed: Invalid credentials or session expired.")
            return AppError(title: "Authentication Failed", description: "Invalid credentials or session expired.")
        case 403:
            logger.error("Forbidden: You do not have permission to access this resource.")
            return AppError(title: "Forbidden", description: "You do not have permission to access this resource.")
        case 500:
            logger.error("Server Error: An error occurred on the server. Please try again later.")
            return AppError(title: "Server Error", description: "An error occurred on the server. Please try again later.")
        default:
            logger.error("Server response error with status code: \(statusCode)")
            return URLError(.badServerResponse)
        }
    }
    
    func validateJWTTokenLocally(_ token: String) -> Bool {
        guard let jwtPayload = JWTUtil.decodeJWT(token),
              let expString = jwtPayload["exp"] as? Double
        else {
            logger.error("Failed to decode JWT token or missing expiration date.")
            return false
        }
        
        let expirationDate = Date(timeIntervalSince1970: expString)
        let isValid = expirationDate > Date()
        logger.info("JWT token validity check: \(isValid ? "Valid" : "Expired")")
        return isValid
    }
    
    func signIn(email: String, password: String) async throws -> LoginResponse {
        let email = email.lowercased()
        
        logger.info("Signing in for email: \(email)")
        
        let apolloClient = await ApolloFactory.getInstance(url: URL(string: Constants.Endpoints.graphqlURL)!).apollo
        
        let loginResponse: LoginResponse = try await withCheckedThrowingContinuation { continuation in
            let loginMutation = LoginMutation(email: email, password: password, deviceId: CryptoKitUtility.sha512(for: KeychainHelper.getUniqueDeviceIdentifier()))

            apolloClient.perform(mutation: loginMutation) { result in
                switch result {
                case .success(let graphQLResult):
                    if let loginData = graphQLResult.data?.login {
                        let jwtToken = loginData.jwtToken
                        let refreshToken = loginData.refreshToken
                        let userId = loginData.userId
                        
                        print("Login succeeded, token: \(jwtToken)")
                        
                        let response = LoginResponse(email: email, jwtToken: jwtToken, refreshToken: refreshToken)
                        continuation.resume(returning: response)
                            
                    } else if let errors = graphQLResult.errors {
                        continuation.resume(throwing: NSError(domain: "GraphQL", code: -1, userInfo: [NSLocalizedDescriptionKey: errors.description]))
                    } else {
                        continuation.resume(throwing: AppError(title: "No data and errors", description: "No data and errors"))
                    }
                    
                case .failure(let error):
                    print("Network error: \(error)")
                    // Resume with a network error
                    continuation.resume(throwing: error)
                }
            }
        }
        
        // Use TokenManager to store tokens
        TokenManager.shared.storeTokens(jwtToken: loginResponse.jwtToken, refreshToken: loginResponse.refreshToken)
        
        logger.info("Sign-in successful for email: \(email)")
        
        AuthenticationManager.isAuthenticated = true

        return loginResponse
    }
    
    func createNewUser(email: String, password: String) async throws -> SignupResponse {
        let email = email.lowercased()
        
        logger.info("Creating new user with email: \(email)")
        
        let apolloClient = await ApolloFactory.getInstance(url: URL(string: Constants.Endpoints.graphqlURL)!).apollo
        
        let response: String = try await withCheckedThrowingContinuation { continuation in
            let registrationMutation = RegisterMutation(email: email, password: password)
            
            apolloClient.perform(mutation: registrationMutation) { result in
                switch result {
                case .success(let graphQLResult):
                    if let str = graphQLResult.data?.register {
                        self.logger.info("User registation successful for email: \(email)")
                    
                        continuation.resume(returning: str)
                    } else if let errors = graphQLResult.errors {
                        self.logger.error("User registration failed for email: \(email) with errors: \(errors.description)")
                        
                        continuation.resume(throwing: NSError(domain: "GraphQL", code: -1, userInfo: [NSLocalizedDescriptionKey: errors.description]))
                    } else {
                        continuation.resume(throwing: AppError(title: "User registration failed", description: "User registration failed"))
                    }
                    
                case .failure(let error):
                    print("Network error: \(error)")
                    // Resume with a network error
                    continuation.resume(throwing: error)
                }
            }
        }
        
        // Sign in after registration
        let loginResponse = try await signIn(email: email, password: password)
        
        logger.info("User registration successful for email: \(email)")
        return SignupResponse(email: loginResponse.email, jwtToken: loginResponse.jwtToken, refreshToken: loginResponse.refreshToken)
    }
    
    func changePassword(newPassword: String) async throws {
        let jwtToken = await getJWTToken()
        
        let url = URL(string: Constants.Endpoints.authenticationURL)!.appendingPathComponent("auth/reset-password")
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "newPassword": newPassword
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        request.setValue(jwtToken, forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("Failed to get HTTP response during password change.")
            throw URLError(.badServerResponse)
        }
        
        guard httpResponse.statusCode == 200 else {
            logger.error("Password change failed with status code: \(httpResponse.statusCode) and response: \(response)")
            throw handleError(for: httpResponse.statusCode)
        }
        
        logger.info("Password changed")
    }
    
    func signOut() async throws {
        TokenManager.shared.clearTokens()
        
        AuthenticationManager.isAuthenticated = false
        
        logger.info("Signed out successfully.")
    }
    
    func isJWTTokenValid(jwtToken: String) -> Bool {
        guard let jwtPayload = JWTUtil.decodeJWT(jwtToken),
              let expString = jwtPayload["exp"] as? Double
        else {
            logger.error("Failed to decode JWT token or missing expiration date.")
            return false
        }
        
        let expirationDate = Date(timeIntervalSince1970: expString)
        let isValid = expirationDate > Date()
        logger.info("JWT token validity check: \(isValid ? "Valid" : "Expired")")
        return isValid
    }
    
    func checkAuthenticationStatus() async -> Bool {
        logger.info("Checking authentication status...")
        do {
            if let jwtToken = await TokenManager.shared.getJWTTokenLocally() {
                if TokenManager.shared.isJWTTokenValidLocally(jwtToken: jwtToken) {
                    logger.info("JWT token is valid.")
                    
                    AuthenticationManager.isAuthenticated = true
                } else {
                    logger.info("JWT token is expired. Attempting to refresh...")
                    try await refreshToken()
                    
                    AuthenticationManager.isAuthenticated = true
                }
            } else {
                logger.info("No JWT token found.")
                
                AuthenticationManager.isAuthenticated = false
            }
        } catch {
            logger.error("Error checking authentication status: \(error.localizedDescription)")
            
            AuthenticationManager.isAuthenticated = false
        }
        
        return AuthenticationManager.isAuthenticated
    }
    
    // Function to refresh JWT token
    private func refreshToken() async throws {
        logger.info("Refreshing JWT token...")
        let refreshToken = TokenManager.shared.getRefreshTokenLocally()
        
        guard let refreshToken = refreshToken else {
            throw AppError(title: "Refresh Token Missing", description: "No refresh token found in Keychain")
        }
        
        let url = URL(string: Constants.Endpoints.authenticationURL)!.appendingPathComponent("auth/refresh")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["refreshToken": refreshToken]
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("Failed to get HTTP response during refresh token request.")
            throw URLError(.badServerResponse)
        }
        
        guard httpResponse.statusCode == 200 else {
            throw handleError(for: httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        let authResponse = try decoder.decode(LoginResponse.self, from: data)
        
        TokenManager.shared.storeTokens(jwtToken: authResponse.jwtToken, refreshToken: authResponse.refreshToken)
        logger.info("Token refreshed successfully.")
    }
    
    public func getJWTToken() async -> String? {
        logger.info("Fetching JWT token...")
        guard let token = await TokenManager.shared.getJWTTokenLocally() else {
            logger.info("No JWT token found locally.")
            return nil
        }
        
        if TokenManager.shared.isJWTTokenValidLocally(jwtToken: token) {
            logger.info("JWT token is valid.")
            return token
        } else {
            logger.info("JWT token is expired. Attempting to refresh...")
            do {
                try await refreshToken()
                return await TokenManager.shared.getJWTTokenLocally()
            } catch {
                logger.error("Failed to refresh token: \(error.localizedDescription)")
                return nil
            }
        }
    }
        
    public func getAuthenticatedUser() async -> LoginResponse? {
        logger.info("Getting authenticated user...")
        guard let jwtToken = await getJWTToken() else {
            logger.info("No valid JWT token found.")
            return nil
        }
        
        if TokenManager.shared.isJWTTokenValidLocally(jwtToken: jwtToken) {
            let jwtInfo = JWTUtil.decodeJWT(jwtToken)
            guard let email = jwtInfo?["sub"] as? String else {
                logger.error("Failed to get email from JWT token.")
                return nil
            }
            
            logger.info("Authenticated user email: \(email)")
            return LoginResponse(email: email, jwtToken: jwtToken, refreshToken: TokenManager.shared.getRefreshTokenLocally() ?? "")
        } else {
            logger.info("JWT token is expired.")
            return nil
        }
    }
}

final class TokenManager: Sendable {
    private let logger = Logger(subsystem: "com.ayushsinghal.Kontest", category: "TokenManager")
    
    private let jwtTokenKey = "jwtToken"
    private let refreshTokenKey = "refreshToken"
    private let keychainService = Constants.keychainAuthTokensServiceName
    
    static let shared = TokenManager()
    
    private init() {}
    
    func validateToken() async throws -> Bool {
        guard let token = await getJWTTokenLocally() else {
            throw NetworkError(title: "Token Missing", description: "JWT token not found.", code: 401)
        }
        
        if isJWTTokenValidLocally(jwtToken: token) {
            return true
        } else {
            // Refresh token if needed
            try await refreshToken()
            return true
        }
    }
    
    // Store tokens in Keychain
    func storeTokens(jwtToken: String, refreshToken: String) {
        logger.info("Storing JWT and refresh tokens.")
        KeychainHelper.storeData(data: jwtToken.data(using: .utf8)!, forService: keychainService, account: jwtTokenKey)
        KeychainHelper.storeData(data: refreshToken.data(using: .utf8)!, forService: keychainService, account: refreshTokenKey)
    }
    
    // Clear tokens from Keychain
    func clearTokens() {
        logger.info("Clearing all tokens from Keychain.")
        KeychainHelper.deleteData(forService: keychainService, account: jwtTokenKey)
        KeychainHelper.deleteData(forService: keychainService, account: refreshTokenKey)
    }
    
    func getJWTTokenLocally() async -> String? {
        logger.info("Fetching JWT token from Keychain.")
        guard let tokenData = KeychainHelper.retrieveData(forService: keychainService, account: jwtTokenKey),
              let token = String(data: tokenData, encoding: .utf8)
        else {
            return nil
        }
        return token
    }
    
    func getRefreshTokenLocally() -> String? {
        logger.info("Fetching refresh token from Keychain.")
        guard let tokenData = KeychainHelper.retrieveData(forService: Constants.keychainAuthTokensServiceName, account: "refreshToken"),
              let token = String(data: tokenData, encoding: .utf8)
        else {
            return nil
        }
        return token
    }
    
    private func refreshToken() async throws {
        // Retrieve the refresh token from Keychain
        logger.info("Attempting to retrieve refresh token from Keychain...")
        guard let refreshToken = getRefreshTokenLocally() else {
            logger.error("Refresh token missing from Keychain.")
            throw AppError(title: "Refresh Token Missing", description: "No refresh token found.")
        }
        logger.info("Refresh token retrieved successfully.")
        
        // Construct the URL for refreshing the token
        let url = URL(string: Constants.Endpoints.authenticationURL)!.appendingPathComponent("auth/refresh")
        logger.info("Constructed URL for refreshing token: \(url)")
        
        // Create the URL request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Prepare the request body
        let body: [String: Any] = ["refreshToken": refreshToken]
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        logger.info("Request body prepared for token refresh: \(body)")
        
        // Perform the network request
        logger.info("Performing network request to refresh token...")
        let (data, response) = try await URLSession.shared.data(for: request)
        logger.info("Network request completed.")
        
        // Ensure the response is successful
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            logger.error("Failed to refresh token. HTTP response status code: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
            throw URLError(.badServerResponse)
        }
        logger.info("Token refresh successful. HTTP response status code: \(httpResponse.statusCode)")
        
        // Decode the new tokens
        logger.info("Decoding new tokens from response...")
        let decoder = JSONDecoder()
        let authResponse = try decoder.decode(LoginResponse.self, from: data)
        logger.info("New tokens decoded successfully.")
        
        // Update Keychain with new tokens
        logger.info("Storing new JWT and refresh tokens in Keychain.")
        storeTokens(jwtToken: authResponse.jwtToken, refreshToken: authResponse.refreshToken)
        logger.info("New tokens stored in Keychain successfully.")
    }
    
    func isJWTTokenValidLocally(jwtToken: String) -> Bool {
        guard let jwtPayload = JWTUtil.decodeJWT(jwtToken),
              let expString = jwtPayload["exp"] as? Double
        else {
            logger.error("Failed to decode JWT token or missing expiration date.")
            return false
        }
        
        let expirationDate = Date(timeIntervalSince1970: expString)
        let isValid = expirationDate > Date()
        logger.info("JWT token validity check: \(isValid ? "Valid" : "Expired")")
        return isValid
    }
}
