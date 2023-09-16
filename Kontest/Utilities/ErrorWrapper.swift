//
//  ErrorWrapper.swift
//  Kontest
//
//  Created by Ayush Singhal on 15/09/23.
//

import Foundation

struct ErrorWrapper: Identifiable, Equatable {
    static func == (lhs: ErrorWrapper, rhs: ErrorWrapper) -> Bool {
        lhs.id == rhs.id
    }

    let id = UUID()
    let error: Error
    let guidance: String
}
