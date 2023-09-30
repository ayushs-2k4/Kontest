//
//  ContentView.swift
//  Kontest
//
//  Created by Ayush Singhal on 30/09/23.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @Binding var panelSelection: Panel?

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
    @State var panelSelection: Panel? = .AllKontestScreen

    return ContentView(panelSelection: $panelSelection)
        .environment(Dependencies.instance.allKontestsViewModel)
        .environment(Router.instance)
        .environment(NetworkMonitor.shared)
        .environment(ErrorState())
}
