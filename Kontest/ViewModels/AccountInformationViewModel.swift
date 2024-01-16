//
//  AccountInformationViewModel.swift
//  Kontest
//
//  Created by Ayush Singhal on 1/16/24.
//

import Foundation
import OSLog

@Observable
class AccountInformationViewModel {
    private let logger = Logger(subsystem: "com.ayushsinghal.Kontest", category: "AccountInformationViewModel")
    
    private init() {
        getAuthenticatedUser()
    }
    
    static let shared = AccountInformationViewModel()
    
    private var user: DBUser?
    
    var firstName: String = ""
    var lastName: String = ""
    var fullName: String = ""
    var collegeName: String = ""
    var collegeState: String = ""
    var fullCollegeName: String = ""
    
    var isLoading: Bool = false
    
    func getAuthenticatedUser() {
        Task {
            self.isLoading = true
            
            do {
                let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
                
                self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
                
                setProperties()
            } catch {
                logger.log("Error in fetching user: \(error)")
            }
            
            self.isLoading = false
        }
    }
    
    func setProperties() {
        self.firstName = self.user?.firstName ?? ""
        self.lastName = self.user?.lastName ?? ""
        self.fullName = (self.user?.firstName ?? "") + " " + (self.user?.lastName ?? "")
        self.collegeName = self.user?.selectedCollege ?? ""
        self.collegeState = self.user?.selectedState ?? ""
        self.fullCollegeName = (self.user?.selectedCollege ?? "") + ", " + (self.user?.selectedState ?? "")
    }
    
    func updateName(firstName: String, lastName: String) {
        UserManager.shared.updateName(firstName: firstName, lastName: lastName, completion: { error in
            
            if let error {
            } else {
                self.getAuthenticatedUser()
            }
        })
    }
}
