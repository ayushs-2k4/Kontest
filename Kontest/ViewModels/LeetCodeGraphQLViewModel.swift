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
    var leetCodeGraphQLAPIDTO: LeetCodeGraphQLAPIDTO?
    var isLoading: Bool = false

    init(username: String) {
        isLoading = true
        fetchUserData(username: username)
    }

    func fetchUserData(username: String) {
        repository.getUserData(username: username) { [weak self] leetCodeGraphQLAPIDTO in
            if let data = leetCodeGraphQLAPIDTO {
                // Handle the data here when the GraphQL query succeeds.
                print("Received data: \(data)")
                self?.leetCodeGraphQLAPIDTO = data
                self?.isLoading = false
            } else {
                // Handle the case when the GraphQL query fails or returns nil data.
                print("Failed to fetch data.")
            }
        }
    }
}
