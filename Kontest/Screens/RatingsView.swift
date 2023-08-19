//
//  RatingsView.swift
//  Kontest
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
            LazyHStack(spacing: hSpacing) {
                CodeForcesScreen(username: codeForcesUsername, bgColor: .green)
                    .clipShape(.rect(cornerRadius: 20.0))
                    .aspectRatio(heroRatio, contentMode: .fit)
                    .containerRelativeFrame(.horizontal, count: columns, spacing: 10)

                LeetcodeScreen(username: leetCodeUsername, bgColor: .cyan)
                    .clipShape(.rect(cornerRadius: 20.0))
                    .aspectRatio(heroRatio, contentMode: .fit)
                    .containerRelativeFrame(.horizontal, count: columns, spacing: 10)
            }
            .scrollTargetLayout()
        }
        .contentMargins(.horizontal, hMargin)
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.viewAligned)
    }

    private var columns: Int {
        sizeClass == .compact ? 1 : regularCount
    }

    var hMargin: CGFloat {
        20.0
    }

    var hSpacing: CGFloat {
        10.0
    }

    var regularCount: Int {
        2
    }

    var heroRatio: CGFloat {
        16.0 / 9.0
    }
}

#Preview {
    RatingsView(codeForcesUsername: "ayushsinghals", leetCodeUsername: "ayushs_2k4")
}
