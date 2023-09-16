//
//  AppError.swift
//  Kontest
//
//  Created by Ayush Singhal on 04/09/23.
//

import Foundation

struct AppError: Error, LocalizedError {
    let title: String
    let description: String

    let actionLabel: String
    let action: (() -> Void)?

    init(title: String, description: String) {
        self.title = title
        self.description = description
        self.action = nil
        self.actionLabel = ""
    }

    init(title: String, description: String, action: @escaping (() -> Void), actionLabel: String) {
        self.title = title
        self.description = description
        self.action = action
        self.actionLabel = actionLabel
    }

    var errorDescription: String? { description }
}
