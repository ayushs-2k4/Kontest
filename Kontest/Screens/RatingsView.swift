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
    let codeChefUsername: String
    let hoveringScaleValue = 1.04

    let bgGradient = RadialGradient(gradient: Gradient(stops: [.init(color: Color(red: 159/255, green: 150/255, blue: 137/255), location: 0.0), .init(color: Color(red: 209/255, green: 204/255, blue: 198/255), location: 0.5)]), center: .center, startRadius: 10, endRadius: 500)

    @Environment(\.horizontalSizeClass) private var sizeClass

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: hSpacing) {
                CodeForcesView(username: codeForcesUsername, bgGradient: bgGradient, hoveringScaleValue: hoveringScaleValue)
                    .clipShape(.rect(cornerRadius: cornerRadius))
                    .aspectRatio(heroRatio, contentMode: .fit)
                    .containerRelativeFrame(.horizontal, count: columns, spacing: 10)

                LeetCodeGraphQLView(username: leetCodeUsername, bgColor: Color(red: 34/255, green: 34/255, blue: 34/255), hoveringScaleValue: hoveringScaleValue)
                    .clipShape(.rect(cornerRadius: cornerRadius))
                    .aspectRatio(heroRatio, contentMode: .fit)
                    .containerRelativeFrame(.horizontal, count: columns, spacing: 10)

                CodeChefView(username: codeChefUsername, bgColor: .brown, hoveringScaleValue: hoveringScaleValue)
                    .clipShape(.rect(cornerRadius: cornerRadius))
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

    private var cornerRadius: CGFloat {
        10
    }

    var hMargin: CGFloat {
        #if os(macOS)
            20
        #else
            0
        #endif
    }

    var hSpacing: CGFloat {
        10.0
    }

    var regularCount: Int {
        2
    }

    var heroRatio: CGFloat {
        18.0/9.0
    }
}

#Preview {
    RatingsView(codeForcesUsername: "ayushsinghals", leetCodeUsername: "ayushs_2k4", codeChefUsername: "ayushs_2k4")
        .environment(Router.instance)
}
