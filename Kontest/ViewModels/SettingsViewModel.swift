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
    
    static let instance = SettingsViewModel()
    
    private let leetcodeUsernameKey = "leetcodeUsername"
    private let codeForcesUsernameKey = "codeForcesUsername"
    
    init() {
        if let leetcodeUsername = UserDefaults.standard.string(forKey: leetcodeUsernameKey) {
            self.leetcodeUsername = leetcodeUsername
        }
        
        if let codeForcesUsername = UserDefaults.standard.string(forKey: codeForcesUsernameKey) {
            self.codeForcesUsername = codeForcesUsername
        }
    }

    func setLeetcodeUsername(newLeetcodeUsername: String) {
        UserDefaults.standard.set(newLeetcodeUsername, forKey: leetcodeUsernameKey)
        leetcodeUsername = newLeetcodeUsername
    }
        
    func setCodeForcesUsername(newCodeForcesUsername: String) {
        UserDefaults.standard.set(newCodeForcesUsername, forKey: codeForcesUsernameKey)
        codeForcesUsername = newCodeForcesUsername
    }
}
