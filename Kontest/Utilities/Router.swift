//
//  Router.swift
//  Kontest
//
//  Created by Ayush Singhal on 25/08/23.
//

import Foundation

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
        if (path.contains(.screen(.SettingsScreen)) || path.contains(.screen(.SettingsScreenType(.ChangeUserNamesScreen))) || path.contains(.screen(.SettingsScreenType(.FilterWebsitesScreen)))), screen == .SettingsScreen {
        } else {
            path.append(SelectionState.screen(screen))
        }
    }

    static let instance: Router = .init()
}
