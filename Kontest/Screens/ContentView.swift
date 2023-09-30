//
//  ContentView.swift
//  Kontest
//
//  Created by Ayush Singhal on 30/09/23.
//

import SwiftUI

enum Panel: Hashable {
    case AllKontestScreen

    case LeetCodeGraphView
    case CodeForcesGraphView
}

struct Sidebar: View {
    @Binding var selection: Panel?

    var body: some View {
        List(selection: $selection) {
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
    @Binding var selection: Panel?

    var body: some View {
        switch selection {
        case .AllKontestScreen:
            AllKontestsScreen()
            
        case .LeetCodeGraphView:
            LeetcodeGraphView()
            
        case .CodeForcesGraphView:
            Text("CodeForcesGraphView")
            
        case nil:
            Text("Nil")
        }
    }
}

struct ContentView: View {
    @State private var selection: Panel? = .AllKontestScreen
//    @State private var selection: Panel? = .LeetCodeGraphView

    var body: some View {
        NavigationSplitView {
            Sidebar(selection: $selection)
        } detail: {
            DetailColumn(selection: $selection)
        }
    }
}

#Preview {
    ContentView()
        .environment(Dependencies.instance.allKontestsViewModel)
        .environment(Router.instance)
        .environment(NetworkMonitor.shared)
//        .environment(errorState)
}
