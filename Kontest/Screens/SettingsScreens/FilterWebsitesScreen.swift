//
//  FilterWebsitesScreen.swift
//  Kontest
//
//  Created by Ayush Singhal on 09/09/23.
//

import SwiftUI
import WidgetKit

struct FilterWebsitesScreen: View {
    let allKontestsViewModel = Dependencies.instance.allKontestsViewModel

    @AppStorage(FilterWebsiteKey.codeForcesKey.rawValue,store: UserDefaults(suiteName: Constants.userDefaultsGroupID)) var codeForcesKey = true
    @AppStorage(FilterWebsiteKey.atCoderKey.rawValue,store: UserDefaults(suiteName: Constants.userDefaultsGroupID)) var atCoderKey = true
    @AppStorage(FilterWebsiteKey.cSAcademyKey.rawValue,store: UserDefaults(suiteName: Constants.userDefaultsGroupID)) var cSAcademyKey = true
    @AppStorage(FilterWebsiteKey.codeChefKey.rawValue,store: UserDefaults(suiteName: Constants.userDefaultsGroupID)) var codeChefKey = true
    @AppStorage(FilterWebsiteKey.hackerRankKey.rawValue,store: UserDefaults(suiteName: Constants.userDefaultsGroupID)) var hackerRankKey = true
    @AppStorage(FilterWebsiteKey.hackerEarthKey.rawValue,store: UserDefaults(suiteName: Constants.userDefaultsGroupID)) var hackerEarthKey = true
    @AppStorage(FilterWebsiteKey.leetCodeKey.rawValue,store: UserDefaults(suiteName: Constants.userDefaultsGroupID)) var leetCodeKey = true
    @AppStorage(FilterWebsiteKey.tophKey.rawValue,store: UserDefaults(suiteName: Constants.userDefaultsGroupID)) var tophKey = true

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
                FilterWebsitesView(siteLogo: Image(.codeForcesLogo), siteName: "CodeForces", borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: "CodeForces"), isSelected: $codeForcesKey)

                FilterWebsitesView(siteLogo: Image(.atCoderLogo), siteName: "AtCoder", borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: "AtCoder"), isSelected: $atCoderKey)

                FilterWebsitesView(siteLogo: Image(.csAcademyLogo), siteName: "CodeForces", borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: "CS Academy"), isSelected: $cSAcademyKey)

                FilterWebsitesView(siteLogo: Image(.codeChefLogo), siteName: "CodeChef", borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: "CodeChef"), isSelected: $codeChefKey)

                FilterWebsitesView(siteLogo: Image(.hackerRankLogo), siteName: "HackerRank", borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: "HackerRank"), isSelected: $hackerRankKey)

                FilterWebsitesView(siteLogo: Image(.hackerEarthLogo), siteName: "HackerEarth", borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: "HackerEarth"), isSelected: $hackerEarthKey)

                FilterWebsitesView(siteLogo: Image(colorScheme == .light ? .leetCodeDarkLogo : .leetCodeWhiteLogo), siteName: "LeetCode", borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: "LeetCode"), isSelected: $leetCodeKey)

                FilterWebsitesView(siteLogo: Image(.tophLogo), siteName: "Toph", borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: "Toph"), isSelected: $tophKey)
            })
        }
        .padding()
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle("Filter Websites")
        .onDisappear {
            allKontestsViewModel.addAllowedWebsites()
            allKontestsViewModel.filterKontests()
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}

#Preview {
    NavigationStack {
        FilterWebsitesScreen()
    }
}

