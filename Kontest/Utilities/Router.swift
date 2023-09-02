//
//  Router.swift
//  Kontest
//
//  Created by Ayush Singhal on 25/08/23.
//

import SwiftUI

enum SelectionState: Hashable {
    case screen(Screen)
    case kontestModel(KontestModel)
}

@Observable
class Router {
    var path = [SelectionState]() {
        didSet {
            currentSelectionState = path.last ?? .screen(.AllKontestScreen)
            print("path: \(path)")
            print("currentSelectionState: \(currentSelectionState)")
        }
    }

    var currentSelectionState: SelectionState = .screen(.AllKontestScreen)
    private init() {}

    func appendScreen(screen: Screen) {
        if currentSelectionState != .screen(.SettingsScreen) {
            path.append(SelectionState.screen(screen))
        }
    }

    static let instance: Router = .init()
}
