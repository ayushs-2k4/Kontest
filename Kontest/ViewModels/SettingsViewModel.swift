//
//  SettingsViewModel.swift
//  Kontest
//
//  Created by Ayush Singhal on 16/08/23.
//

import SwiftUI

@Observable
class SettingsViewModel {
    var leetcodeUsername: String = ""
    var codeForcesUsername: String = ""
    var codeChefUsername: String = ""
    
    static let instance = SettingsViewModel()
    
    private let leetcodeUsernameKey = "leetcodeUsername"
    private let codeForcesUsernameKey = "codeForcesUsername"
    private let codeChefUsernameKey = "codeChefUsername"
    
    init() {
        if let leetcodeUsername = UserDefaults.standard.string(forKey: leetcodeUsernameKey) {
            self.leetcodeUsername = leetcodeUsername
        }
        
        if let codeForcesUsername = UserDefaults.standard.string(forKey: codeForcesUsernameKey) {
            self.codeForcesUsername = codeForcesUsername
        }
        
        if let codeChefUsername = UserDefaults.standard.string(forKey: codeChefUsernameKey) {
            self.codeChefUsername = codeChefUsername
        }
    }

    func setLeetcodeUsername(newLeetcodeUsername: String) {
        leetcodeUsername = newLeetcodeUsername.trimmingCharacters(in: .whitespacesAndNewlines)
        UserDefaults.standard.set(leetcodeUsername, forKey: leetcodeUsernameKey)
    }
        
    func setCodeForcesUsername(newCodeForcesUsername: String) {
        codeForcesUsername = newCodeForcesUsername.trimmingCharacters(in: .whitespacesAndNewlines)
        UserDefaults.standard.set(codeForcesUsername, forKey: codeForcesUsernameKey)
    }
    
    func setCodeChefUsername(newCodeChefUsername: String) {
        codeChefUsername = newCodeChefUsername.trimmingCharacters(in: .whitespacesAndNewlines)
        UserDefaults.standard.set(codeChefUsername, forKey: codeChefUsernameKey)
    }
}
