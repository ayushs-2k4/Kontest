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
    
    func getRatingsTitle() -> (title: String, color: Color) {
        guard let codeForcesProfile else { return ("U n r a t e d".uppercased(), .black) }
        
        let newRating = codeForcesProfile.result[codeForcesProfile.result.count - 1].newRating

        return if newRating <= 1199 {
            ("N e w b i e".uppercased(), .white)
        } else if newRating <= 1399 {
            ("P u p i l".uppercased(), .green.opacity(0.5))
        } else if newRating <= 1599 {
            ("S p e c i a l i s t".uppercased(), .cyan)
        } else if newRating <= 1899 {
            ("E x p e r t".uppercased(), .blue)
        } else if newRating <= 2199 {
            ("Candidate Master".uppercased(), Color(red: 255/255, green: 85/255, blue: 254/255))
        } else if newRating <= 2299 {
            ("M a s t e r".uppercased(), .orange)
        } else if newRating <= 2399 {
            ("International Master".uppercased(), .orange)
        } else if newRating <= 2599 {
            ("Grandmaster".uppercased(), .red)
        } else if newRating <= 2899 {
            ("International Grandmaster".uppercased(), .red)
        } else {
            ("Legendary Grandmaster".uppercased(), .red)
        }
    }
}
