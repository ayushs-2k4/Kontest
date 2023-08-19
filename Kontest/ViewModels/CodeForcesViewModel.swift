//
//  CodeForcesViewModel.swift
//  Kontest
//
//  Created by Ayush Singhal on 16/08/23.
//

import SwiftUI

@Observable
class CodeForcesViewModel {
    let codeForcesAPIRepository = CodeForcesAPIRepository()
    
    var codeForcesProfile: CodeForcesAPIModel?
    
    var isLoading = false
    
    var error: Error?
    
    init(username: String) {
        self.isLoading = true
        Task {
            await self.getCodeForcesProfile(username: username)
            self.isLoading = false
        }
    }
    
    func getCodeForcesProfile(username: String) async {
        do {
            let fetchedCodeForcesProfile = try await codeForcesAPIRepository.getUserData(username: username)
            print(fetchedCodeForcesProfile)
            
            self.codeForcesProfile = CodeForcesAPIModel.from(dto: fetchedCodeForcesProfile)
        } catch {
            self.error = error
            print("error in fetching CodeForces Profile: \(error)")
        }
    }
}
