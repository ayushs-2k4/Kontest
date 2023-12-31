//
//  Sidebar.swift
//  Kontest
//
//  Created by Ayush Singhal on 30/09/23.
//

import SwiftUI

struct Sidebar: View {
    @Binding var panelSelection: Panel?
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        List(selection: $panelSelection) {
            NavigationLink(value: Panel.AllKontestScreen) {
                Label("All Kontests", systemImage: "chart.bar")
            }

            Section("Ranking Graphs") {
                NavigationLink(value: Panel.CodeForcesGraphView) {
                    Label {
                        Text("CodeForces Rankings")
                    } icon: {
                        Image(.codeForcesLogo)
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                }

                NavigationLink(value: Panel.LeetCodeGraphView) {
                    Label {
                        Text("LeetCode Rankings")
                    } icon: {
                        Image(colorScheme == .dark ? .leetCodeWhiteLogo : .leetCodeDarkLogo)
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                }
            }
        }
    }
}
