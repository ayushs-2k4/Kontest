//
//  DetailColumn.swift
//  Kontest
//
//  Created by Ayush Singhal on 30/09/23.
//

import SwiftUI

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

        case .CodeChefGraphView:
            CodeChefGraphView()

        case nil:
            Text("Nil")
        }
    }
}
