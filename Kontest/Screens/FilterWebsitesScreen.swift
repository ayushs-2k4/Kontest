//
//  FilterWebsitesScreen.swift
//  Kontest
//
//  Created by Ayush Singhal on 09/09/23.
//

import SwiftUI

struct FilterWebsitesScreen: View {
    let allKontestsViewModel = AllKontestsViewModel.instance

    @AppStorage(FilterWebsiteKey.codeForcesKey.rawValue) var codeForcesKey = true
    @AppStorage(FilterWebsiteKey.atCoderKey.rawValue) var atCoderKey = true
    @AppStorage(FilterWebsiteKey.cSAcademyKey.rawValue) var cSAcademyKey = true
    @AppStorage(FilterWebsiteKey.codeChefKey.rawValue) var codeChefKey = true
    @AppStorage(FilterWebsiteKey.hackerRankKey.rawValue) var hackerRankKey = true
    @AppStorage(FilterWebsiteKey.hackerEarthKey.rawValue) var hackerEarthKey = true
    @AppStorage(FilterWebsiteKey.leetCodeKey.rawValue) var leetCodeKey = true
    @AppStorage(FilterWebsiteKey.tophKey.rawValue) var tophKey = true

    @Environment(\.colorScheme) private var colorScheme

    let columns: [GridItem]

    init() {
        #if os(macOS)
        columns = [GridItem(.flexible()),
                   GridItem(.flexible()),
                   GridItem(.flexible()),
                   GridItem(.flexible())]
        #else
        columns = [GridItem(.flexible()),
                   GridItem(.flexible())]
        #endif
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, content: {
                FilterWebsitesView(siteLogo: Image(.codeForcesLogo), siteName: "CodeForces", borderColor: KontestModel.getColorForIdentifier(site: "CodeForces"), isSelected: $codeForcesKey)

                FilterWebsitesView(siteLogo: Image(.atCoderLogo), siteName: "AtCoder", borderColor: KontestModel.getColorForIdentifier(site: "AtCoder"), isSelected: $atCoderKey)

                FilterWebsitesView(siteLogo: Image(.csAcademyLogo), siteName: "CodeForces", borderColor: KontestModel.getColorForIdentifier(site: "CS Academy"), isSelected: $cSAcademyKey)

                FilterWebsitesView(siteLogo: Image(.codeChefLogo), siteName: "CodeChef", borderColor: KontestModel.getColorForIdentifier(site: "CodeChef"), isSelected: $codeChefKey)

                FilterWebsitesView(siteLogo: Image(.hackerRankLogo), siteName: "HackerRank", borderColor: KontestModel.getColorForIdentifier(site: "HackerRank"), isSelected: $hackerRankKey)

                FilterWebsitesView(siteLogo: Image(.hackerEarthLogo), siteName: "HackerEarth", borderColor: KontestModel.getColorForIdentifier(site: "HackerEarth"), isSelected: $hackerEarthKey)

                FilterWebsitesView(siteLogo: Image(colorScheme == .light ? .leetCodeDarkLogo : .leetCodeWhiteLogo), siteName: "LeetCode", borderColor: KontestModel.getColorForIdentifier(site: "LeetCode"), isSelected: $leetCodeKey)

                FilterWebsitesView(siteLogo: Image(.tophLogo), siteName: "Toph", borderColor: KontestModel.getColorForIdentifier(site: "Toph"), isSelected: $tophKey)
            })
        }
        .padding()
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle("Filter Websites")
        .onDisappear {
            allKontestsViewModel.addAllowedWebsites()
            allKontestsViewModel.filterKontests()
        }
    }
}

#Preview {
    NavigationStack {
        FilterWebsitesScreen()
    }
}

