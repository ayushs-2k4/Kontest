//
//  Screens.swift
//  Kontest
//
//  Created by Ayush Singhal on 16/08/23.
//

import Foundation

enum Screen: Hashable {
    case AllKontestScreen
    case SettingsScreen
    case SettingsScreenType(SettingsScreens)
    case PendingNotificationsScreen
}

enum SettingsScreens {
    case ChangeUserNamesScreen
    case FilterWebsitesScreen
}
