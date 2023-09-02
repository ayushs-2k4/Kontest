//
//  Router.swift
//  Kontest
//
//  Created by Ayush Singhal on 25/08/23.
//

import SwiftUI

@Observable
class Router {
    var path: NavigationPath = .init() {
        didSet {
            currentScreen = .AllKontestScreen
        }
    }

    var currentScreen: Screens = .AllKontestScreen
    private init() {}

    func appendScreen(screen: Screens) {
        currentScreen = screen
        path.append(screen)
    }

    static let instance: Router = .init()
}
