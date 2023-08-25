//
//  Router.swift
//  Kontest
//
//  Created by Ayush Singhal on 25/08/23.
//

import SwiftUI

@Observable
class Router {
    var path: NavigationPath = .init()
    private init() {}

    static let instance: Router = Router()
}
