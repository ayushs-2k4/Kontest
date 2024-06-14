//
//  ChangeUsernameViewModel.swift
//  Kontest
//
//  Created by Ayush Singhal on 16/08/23.
//

import Foundation

@Observable
final class ChangeUsernameViewModel: Sendable {
    var leetcodeUsername: String = ""
    var codeForcesUsername: String = ""
    var codeChefUsername: String = ""
    
    private let leetcodeUsernameKey = "leetcodeUsername"
    private let codeForcesUsernameKey = "codeForcesUsername"
    private let codeChefUsernameKey = "codeChefUsername"
    
    init() {
        if let leetcodeUsername = UserDefaults(suiteName: Constants.userDefaultsGroupID)!.string(forKey: leetcodeUsernameKey) {
            self.leetcodeUsername = leetcodeUsername
        }
        
        if let codeForcesUsername = UserDefaults(suiteName: Constants.userDefaultsGroupID)!.string(forKey: codeForcesUsernameKey) {
            self.codeForcesUsername = codeForcesUsername
        }
        
        if let codeChefUsername = UserDefaults(suiteName: Constants.userDefaultsGroupID)!.string(forKey: codeChefUsernameKey) {
            self.codeChefUsername = codeChefUsername
        }
    }

    func setLeetcodeUsername(newLeetcodeUsername: String) {
        leetcodeUsername = newLeetcodeUsername.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        UserDefaults(suiteName: Constants.userDefaultsGroupID)!.set(leetcodeUsername, forKey: leetcodeUsernameKey)
        Dependencies.instance.changeLeetcodeUsername(leetCodeUsername: newLeetcodeUsername)
    }
        
    func setCodeForcesUsername(newCodeForcesUsername: String) {
        codeForcesUsername = newCodeForcesUsername.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        UserDefaults(suiteName: Constants.userDefaultsGroupID)!.set(codeForcesUsername, forKey: codeForcesUsernameKey)
        Dependencies.instance.changeCodeForcesUsername(codeForcesUsername: newCodeForcesUsername)
    }
    
    func setCodeChefUsername(newCodeChefUsername: String) {
        codeChefUsername = newCodeChefUsername.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        UserDefaults(suiteName: Constants.userDefaultsGroupID)!.set(codeChefUsername, forKey: codeChefUsernameKey)
        Dependencies.instance.changeCodeChefUsername(codeChefUsername: newCodeChefUsername)
    }
}
