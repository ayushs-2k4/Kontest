//
//  Sidebar.swift
//  Kontest
//
//  Created by Ayush Singhal on 30/09/23.
//

import SwiftUI

struct Sidebar: View {
    @Binding var panelSelection: Panel?

    var body: some View {
        List(selection: $panelSelection) {
            NavigationLink(value: Panel.AllKontestScreen) {
                Text("All Kontests")
            }

            Section("Ranking Graphs") {
                NavigationLink(value: Panel.CodeForcesGraphView) {
                    Text("CodeForces Rankings")
                }

                NavigationLink(value: Panel.LeetCodeGraphView) {
                    Text("LeetCode Rankings")
                }
            }
        }
        #if os(macOS)
        .navigationSplitViewColumnWidth(min: 180, ideal: 200, max: 250)
        #endif
    }
}
