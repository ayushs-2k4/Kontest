//
//  ContentView.swift
//  Kontest
//
//  Created by Ayush Singhal on 30/09/23.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @State private var panelSelection: Panel? = .AllKontestScreen

    var body: some View {
        NavigationSplitView {
            Sidebar(panelSelection: $panelSelection)
        } detail: {
            DetailColumn(panelSelection: $panelSelection)
        }
        .onAppear {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}

#Preview {
    ContentView()
        .environment(Dependencies.instance.allKontestsViewModel)
        .environment(Router.instance)
        .environment(NetworkMonitor.shared)
        .environment(ErrorState())
}
