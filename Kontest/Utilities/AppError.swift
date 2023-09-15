//
//  AppError.swift
//  Kontest
//
//  Created by Ayush Singhal on 04/09/23.
//

import Foundation

struct AppError: Error, LocalizedError {
    let description: String

    var errorDescription: String? { description }
}
