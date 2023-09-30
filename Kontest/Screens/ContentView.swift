//
//  ContentView.swift
//  Kontest
//
//  Created by Ayush Singhal on 30/09/23.
//

import SwiftUI
import WidgetKit

enum Panel: Hashable {
    case AllKontestScreen

    case LeetCodeGraphView
    case CodeForcesGraphView
}

struct Sidebar: View {
    @Binding var panelSelection: Panel?

    var body: some View {
        List(selection: $panelSelection) {
            NavigationLink(value: Panel.AllKontestScreen) {
                Text("AllKontestsScreen")
            }

            Section("Ranking Graphs") {
                NavigationLink(value: Panel.LeetCodeGraphView) {
                    Text("LeetCode Graph")
                }

                NavigationLink(value: Panel.CodeForcesGraphView) {
                    Text("CodeForces Graph")
                }
            }
        }
        #if os(macOS)
        .navigationSplitViewColumnWidth(min: 150, ideal: 200, max: 250)
        #endif
    }
}

struct DetailColumn: View {
    @Binding var panelSelection: Panel?

    var body: some View {
        switch panelSelection {
        case .AllKontestScreen:
            AllKontestsScreen()
            
        case .LeetCodeGraphView:
            LeetcodeGraphView()
            
        case .CodeForcesGraphView:
            CodeForcesGraphView()
            
        case nil:
            Text("Nil")
        }
    }
}

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
