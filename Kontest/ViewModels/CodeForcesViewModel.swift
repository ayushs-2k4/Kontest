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
    
    var codeForcesRatings: CodeForcesUserRatingAPIModel?
    var codeForcesUserInfos: CodeForcesUserInfoAPIModel?
    
    var isLoading = false
    
    var error: Error?
    
    init(username: String) {
        self.isLoading = true
        Task {
            await self.getCodeForcesRatings(username: username)
            await self.getCodeForcesUserInfo(username: username)
            self.isLoading = false
        }
    }
    
    func getCodeForcesRatings(username: String) async {
        do {
            let fetchedCodeForcesRatings = try await codeForcesAPIRepository.getUserRating(username: username)
            print(fetchedCodeForcesRatings)
            
            self.codeForcesRatings = CodeForcesUserRatingAPIModel.from(dto: fetchedCodeForcesRatings)
        } catch {
            self.error = error
            print("error in fetching CodeForces Rating: \(error)")
        }
    }
    
    func getRatingsTitle() -> (title: String, color: Color) {
        guard let codeForcesRatings else { return ("U n r a t e d".uppercased(), .black) }
        
        let newRating = codeForcesRatings.result[codeForcesRatings.result.count - 1].newRating

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
    
    func getCodeForcesUserInfo(username: String) async {
        do {
            let fetchedCodeForcesUserInfo = try await codeForcesAPIRepository.getUserInfo(username: username)
            print(fetchedCodeForcesUserInfo)
            
            self.codeForcesUserInfos = CodeForcesUserInfoAPIModel.from(dto: fetchedCodeForcesUserInfo)
        } catch {
            self.error = error
            print("error in fetching CodeForces User Info: \(error)")
        }
    }
}
