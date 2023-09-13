//
//  NoKontestsDueToFiltersScreen.swift
//  Kontest
//
//  Created by Ayush Singhal on 14/09/23.
//

import SwiftUI

struct NoKontestsDueToFiltersScreen: View {
    @Environment(Router.self) private var router
    
    var body: some View {
        Section {
            Text("Change filters to see kontests.")
            Button("Filter Websites") {
                router.appendScreen(screen: .SettingsScreenType(.FilterWebsitesScreen))
            }
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

#Preview {
    NoKontestsDueToFiltersScreen()
}
