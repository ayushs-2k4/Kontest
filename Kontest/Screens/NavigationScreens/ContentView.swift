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
    @State private var coluVis: NavigationSplitViewVisibility = .automatic
    let path = Router.instance.path

    let deviceType = getDeviceType()

    var body: some View {
        if deviceType == .iPadOS || deviceType == .macOS {
            GeometryReader { geometryProxy in
                NavigationSplitView(columnVisibility: $coluVis) {
                    Sidebar(panelSelection: $panelSelection)
                    #if os(macOS)
                        .navigationSplitViewColumnWidth(min: 200, ideal: 200, max: max(250, geometryProxy.size.width / 5))
                    #endif
                } detail: {
                    DetailColumn(panelSelection: $panelSelection)
                }
                .onAppear {
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
        } else if deviceType == .iOS {
            TabView(selection: $panelSelection) {
                AllKontestsScreen()
                    .tabItem {
                        Label("All Kontests", systemImage: "chart.bar")
                    }
                #if os(iOS)
                    .toolbar(path.contains(.screen(.SettingsScreen)) ? .hidden : .visible, for: .tabBar)
                    .animation(path.contains(.screen(.SettingsScreen)) ? nil : .default, value: path)
                #endif

                CodeForcesGraphView()
                    .tabItem {
                        Label("CodeForces Rankings", image: .codeForcesLogoSmall)
                    }

                LeetcodeGraphView()
                    .tabItem {
                        Label("LeetCode Rankings", image: .leetCodeLogoSmall)
                    }
            }
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
