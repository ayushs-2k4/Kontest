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

    @AppStorage(FilterWebsiteKey.atCoderKey.rawValue, store: UserDefaults(suiteName: Constants.userDefaultsGroupID)) var atCoderKey = true

    @AppStorage(FilterWebsiteKey.codeChefKey.rawValue, store: UserDefaults(suiteName: Constants.userDefaultsGroupID)) var codeChefKey = true

    @AppStorage(FilterWebsiteKey.codeForcesKey.rawValue, store: UserDefaults(suiteName: Constants.userDefaultsGroupID)) var codeForcesKey = true

    @AppStorage(FilterWebsiteKey.codingNinjasKey.rawValue, store: UserDefaults(suiteName: Constants.userDefaultsGroupID)) var codingNinjasKey = true

    @AppStorage(FilterWebsiteKey.cSAcademyKey.rawValue, store: UserDefaults(suiteName: Constants.userDefaultsGroupID)) var cSAcademyKey = true

    @AppStorage(FilterWebsiteKey.geeksForGeeksKey.rawValue, store: UserDefaults(suiteName: Constants.userDefaultsGroupID)) var geeksForGeeksKey = true

    @AppStorage(FilterWebsiteKey.hackerEarthKey.rawValue, store: UserDefaults(suiteName: Constants.userDefaultsGroupID)) var hackerEarthKey = true

    @AppStorage(FilterWebsiteKey.hackerRankKey.rawValue, store: UserDefaults(suiteName: Constants.userDefaultsGroupID)) var hackerRankKey = true

    @AppStorage(FilterWebsiteKey.leetCodeKey.rawValue, store: UserDefaults(suiteName: Constants.userDefaultsGroupID)) var leetCodeKey = true

    @AppStorage(FilterWebsiteKey.projectEulerKey.rawValue, store: UserDefaults(suiteName: Constants.userDefaultsGroupID)) var projectEulerKey = true

    @AppStorage(FilterWebsiteKey.topCodeKey.rawValue, store: UserDefaults(suiteName: Constants.userDefaultsGroupID)) var topCodeKey = true

    @AppStorage(FilterWebsiteKey.tophKey.rawValue, store: UserDefaults(suiteName: Constants.userDefaultsGroupID)) var tophKey = true

    @AppStorage(FilterWebsiteKey.yukiCoderKey.rawValue, store: UserDefaults(suiteName: Constants.userDefaultsGroupID)) var yukiCoderKey = true

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
                FilterWebsitesView(siteLogo: Image(.atCoderLogo), siteName: "AtCoder", borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: "AtCoder"), isSelected: $atCoderKey)

                FilterWebsitesView(siteLogo: Image(.codeChefLogo), siteName: "CodeChef", borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: "CodeChef"), isSelected: $codeChefKey)

                FilterWebsitesView(siteLogo: Image(.codeForcesLogo), siteName: "CodeForces", borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: "CodeForces"), isSelected: $codeForcesKey)

                FilterWebsitesView(siteLogo: Image(.codingNinjasLogo), siteName: "Coding Ninjas", borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: "Coding Ninjas"), isSelected: $codingNinjasKey)

                FilterWebsitesView(siteLogo: Image(.csAcademyLogo), siteName: "CodeForces", borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: "CS Academy"), isSelected: $cSAcademyKey)

                FilterWebsitesView(siteLogo: Image(.geeksForGeeksLogo), siteName: "Geeks For Geeks", borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: "Geeks For Geeks"), isSelected: $geeksForGeeksKey)

                FilterWebsitesView(siteLogo: Image(.hackerEarthLogo), siteName: "HackerEarth", borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: "HackerEarth"), isSelected: $hackerEarthKey)

                FilterWebsitesView(siteLogo: Image(.hackerRankLogo), siteName: "HackerRank", borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: "HackerRank"), isSelected: $hackerRankKey)

                FilterWebsitesView(siteLogo: Image(colorScheme == .light ? .leetCodeDarkLogo : .leetCodeDarkLogo), siteName: "LeetCode", borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: "LeetCode"), isSelected: $leetCodeKey)

                FilterWebsitesView(siteLogo: Image(.projectEulerLogo), siteName: "Project Euler", borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: "Project Euler"), isSelected: $projectEulerKey)

                FilterWebsitesView(siteLogo: colorScheme == .light ? Image(.topCoderLightLogo) : Image(.topCoderDarkLogo), siteName: "TopCoder", borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: "TopCoder", theme: colorScheme), isSelected: $topCodeKey)

                FilterWebsitesView(siteLogo: Image(.tophLogo), siteName: "Toph", borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: "Toph"), isSelected: $tophKey)

                FilterWebsitesView(siteLogo: Image(.yukiCoderLogo), siteName: "Yuki Coder", borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: "Yuki Coder"), isSelected: $yukiCoderKey)
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
            .frame(width: 500, height: 500)
    }
}
