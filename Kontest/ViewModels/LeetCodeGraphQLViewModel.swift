//
//  LeetCodeGraphQLViewModel.swift
//  Kontest
//
//  Created by Ayush Singhal on 04/09/23.
//

import Foundation

@Observable
class LeetCodeGraphQLViewModel {
    let repository = LeetCodeAPIGraphQLRepository()
    var leetCodeGraphQLAPIModel: LeetCodeUserProfileGraphQLAPIModel?
    var isLoading: Bool = false

    init(username: String) {
        isLoading = true
        fetchUserData(username: username)
    }

    func fetchUserData(username: String) {
        repository.getUserData(username: username) { [weak self] leetCodeUserProfileGraphQLAPIDTO in
            if let leetCodeUserProfileGraphQLAPIDTO {
                // Handle the data here when the GraphQL query succeeds.
                print("Received data: \(leetCodeUserProfileGraphQLAPIDTO)")
                self?.leetCodeGraphQLAPIModel = LeetCodeUserProfileGraphQLAPIModel.from(leetCodeUserProfileGraphQLAPIDTO: leetCodeUserProfileGraphQLAPIDTO)
                self?.isLoading = false
            } else {
                // Handle the case when the GraphQL query fails or returns nil data.
                print("Failed to fetch data.")
            }
        }
    }
}
