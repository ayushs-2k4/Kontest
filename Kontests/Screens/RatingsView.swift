//
//  RatingsView.swift
//  Kontests
//
//  Created by Ayush Singhal on 16/08/23.
//

import SwiftUI

struct RatingsView: View {
    let codeForcesUsername: String
    let leetCodeUsername: String

    @Environment(\.horizontalSizeClass) private var sizeClass

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                CodeForcesScreen(username: codeForcesUsername, bgColor: .green)
                    .clipShape(.rect(cornerRadius: 20.0))
                    .padding()
                    .frame(minWidth: 200, minHeight: 200)
                    .aspectRatio(contentMode: .fit)
                    .containerRelativeFrame(.horizontal, count: columns, spacing: 10)
                    .scrollTargetLayout()

                LeetcodeScreen(username: leetCodeUsername, bgColor: .cyan)
                    .clipShape(.rect(cornerRadius: 20.0))
                    .padding()
                    .frame(minWidth: 200, minHeight: 200)
                    .aspectRatio(contentMode: .fit)
                    .containerRelativeFrame(.horizontal, count: 1, spacing: 10)
                    .scrollTargetLayout()
            }
        }
        .scrollTargetBehavior(.paging)
        .scrollIndicators(.hidden)
    }

    private var columns: Int {
        sizeClass == .compact ? 1 : regularCount
    }

    var regularCount: Int {
        1
    }
}

#Preview {
    RatingsView(codeForcesUsername: "ayushsinghals", leetCodeUsername: "ayushs_2k4")
}
