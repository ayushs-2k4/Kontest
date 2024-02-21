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

    @AppStorage(FilterWebsiteKey.topCoderKey.rawValue, store: UserDefaults(suiteName: Constants.userDefaultsGroupID)) var topCodeKey = true

    @AppStorage(FilterWebsiteKey.tophKey.rawValue, store: UserDefaults(suiteName: Constants.userDefaultsGroupID)) var tophKey = true

    @AppStorage(FilterWebsiteKey.yukiCoderKey.rawValue, store: UserDefaults(suiteName: Constants.userDefaultsGroupID)) var yukiCoderKey = true

    @AppStorage(FilterWebsiteKey.cupsOnlineKey.rawValue, store: UserDefaults(suiteName: Constants.userDefaultsGroupID)) var cupsOnlineKey = true

    @AppStorage(Constants.maximumDurationOfAKontestInMinutesKey, store: UserDefaults(suiteName: Constants.userDefaultsGroupID)) var maximumDurationOfAKontestInMinutesKey = Double(Constants.maximumLimitOfMinutesOfKontest)

    @AppStorage(Constants.minimumDurationOfAKontestInMinutesKey, store: UserDefaults(suiteName: Constants.userDefaultsGroupID)) var minimumDurationOfAKontestInMinutesKey = Double(Constants.minimumLimitOfMinutesOfKontest)

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
            LazyVGrid(columns: columns,
                      content: {
                          FilterWebsitesView(
                              siteLogo: Image(KontestModel.getLogo(siteAbbreviation: Constants.SiteAbbreviations.AtCoder.rawValue, colorScheme: colorScheme)),
                              siteName: "AtCoder",
                              borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: Constants.SiteAbbreviations.AtCoder.rawValue),
                              siteAbbreviation: Constants.SiteAbbreviations.AtCoder.rawValue,
                              isSelected: $atCoderKey
                          )

                          FilterWebsitesView(
                              siteLogo: Image(KontestModel.getLogo(siteAbbreviation: Constants.SiteAbbreviations.CodeChef.rawValue, colorScheme: colorScheme)),
                              siteName: "CodeChef",
                              borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: Constants.SiteAbbreviations.CodeChef.rawValue),
                              siteAbbreviation: Constants.SiteAbbreviations.CodeChef.rawValue,
                              isSelected: $codeChefKey
                          )

                          FilterWebsitesView(
                              siteLogo: Image(KontestModel.getLogo(siteAbbreviation: Constants.SiteAbbreviations.CodeForces.rawValue, colorScheme: colorScheme)),
                              siteName: "CodeForces",
                              borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: Constants.SiteAbbreviations.CodeForces.rawValue),
                              siteAbbreviation: Constants.SiteAbbreviations.CodeForces.rawValue,
                              isSelected: $codeForcesKey
                          )

                          FilterWebsitesView(
                              siteLogo: Image(KontestModel.getLogo(siteAbbreviation: Constants.SiteAbbreviations.CodingNinjas.rawValue, colorScheme: colorScheme)),
                              siteName: "Coding Ninjas",
                              borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: Constants.SiteAbbreviations.CodingNinjas.rawValue),
                              siteAbbreviation: Constants.SiteAbbreviations.CodingNinjas.rawValue,
                              isSelected: $codingNinjasKey
                          )

                          FilterWebsitesView(
                              siteLogo: Image(KontestModel.getLogo(siteAbbreviation: Constants.SiteAbbreviations.CSAcademy.rawValue, colorScheme: colorScheme)),
                              siteName: "CS Academy",
                              borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: Constants.SiteAbbreviations.CSAcademy.rawValue),
                              siteAbbreviation: Constants.SiteAbbreviations.CSAcademy.rawValue,
                              isSelected: $cSAcademyKey
                          )

                          FilterWebsitesView(
                              siteLogo: Image(KontestModel.getLogo(siteAbbreviation: Constants.SiteAbbreviations.CupsOnline.rawValue, colorScheme: colorScheme)),
                              siteName: "Cups.Online",
                              borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: Constants.SiteAbbreviations.CupsOnline.rawValue),
                              siteAbbreviation: Constants.SiteAbbreviations.CupsOnline.rawValue,
                              isSelected: $cupsOnlineKey
                          )

                          FilterWebsitesView(
                              siteLogo: Image(KontestModel.getLogo(siteAbbreviation: Constants.SiteAbbreviations.GeeksForGeeks.rawValue, colorScheme: colorScheme)),
                              siteName: "Geeks For Geeks",
                              borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: Constants.SiteAbbreviations.GeeksForGeeks.rawValue),
                              siteAbbreviation: Constants.SiteAbbreviations.GeeksForGeeks.rawValue,
                              isSelected: $geeksForGeeksKey
                          )

                          FilterWebsitesView(
                              siteLogo: Image(KontestModel.getLogo(siteAbbreviation: Constants.SiteAbbreviations.HackerEarth.rawValue, colorScheme: colorScheme)),
                              siteName: "HackerEarth",
                              borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: Constants.SiteAbbreviations.HackerEarth.rawValue),
                              siteAbbreviation: Constants.SiteAbbreviations.HackerEarth.rawValue,
                              isSelected: $hackerEarthKey
                          )

                          FilterWebsitesView(
                              siteLogo: Image(KontestModel.getLogo(siteAbbreviation: Constants.SiteAbbreviations.HackerRank.rawValue, colorScheme: colorScheme)),
                              siteName: Constants.SiteAbbreviations.HackerRank.rawValue,
                              borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: Constants.SiteAbbreviations.HackerRank.rawValue),
                              siteAbbreviation: Constants.SiteAbbreviations.HackerRank.rawValue,
                              isSelected: $hackerRankKey
                          )

                          FilterWebsitesView(
                              siteLogo: Image(KontestModel.getLogo(siteAbbreviation: Constants.SiteAbbreviations.LeetCode.rawValue, colorScheme: colorScheme)),
                              siteName: "LeetCode",
                              borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: Constants.SiteAbbreviations.LeetCode.rawValue),
                              siteAbbreviation: Constants.SiteAbbreviations.LeetCode.rawValue,
                              isSelected: $leetCodeKey
                          )

                          FilterWebsitesView(
                              siteLogo: Image(KontestModel.getLogo(siteAbbreviation: Constants.SiteAbbreviations.ProjectEuler.rawValue, colorScheme: colorScheme)),
                              siteName: "Project Euler",
                              borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: Constants.SiteAbbreviations.ProjectEuler.rawValue),
                              siteAbbreviation: Constants.SiteAbbreviations.ProjectEuler.rawValue,
                              isSelected: $projectEulerKey
                          )

                          FilterWebsitesView(
                              siteLogo: Image(KontestModel.getLogo(siteAbbreviation: Constants.SiteAbbreviations.TopCoder.rawValue, colorScheme: colorScheme)),
                              siteName: "TopCoder",
                              borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: Constants.SiteAbbreviations.TopCoder.rawValue, colorScheme: colorScheme),
                              siteAbbreviation: Constants.SiteAbbreviations.TopCoder.rawValue,
                              isSelected: $topCodeKey
                          )

                          FilterWebsitesView(
                              siteLogo: Image(KontestModel.getLogo(siteAbbreviation: Constants.SiteAbbreviations.Toph.rawValue, colorScheme: colorScheme)),
                              siteName: "Toph",
                              borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: Constants.SiteAbbreviations.Toph.rawValue),
                              siteAbbreviation: Constants.SiteAbbreviations.Toph.rawValue,
                              isSelected: $tophKey
                          )

                          FilterWebsitesView(
                              siteLogo: Image(KontestModel.getLogo(siteAbbreviation: Constants.SiteAbbreviations.YukiCoder.rawValue, colorScheme: colorScheme)),
                              siteName: "Yuki Coder",
                              borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: Constants.SiteAbbreviations.YukiCoder.rawValue),
                              siteAbbreviation: Constants.SiteAbbreviations.YukiCoder.rawValue,
                              isSelected: $yukiCoderKey
                          )

                      })

            // Min Duration Slider
            MinutesSelectionSlider(
                message: "Select Min Duration of Kontest: \(getMessage(totalMinutes: Int(minimumDurationOfAKontestInMinutesKey)))",
                minimumMinutes: Double(Constants.minimumLimitOfMinutesOfKontest),
                maximumMinutes: Double(Constants.maximumLimitOfMinutesOfKontest),
                steps: 10,
                onEditingChanged: { _ in
                    if minimumDurationOfAKontestInMinutesKey > maximumDurationOfAKontestInMinutesKey {
                        maximumDurationOfAKontestInMinutesKey = minimumDurationOfAKontestInMinutesKey
                    }
                },
                currentMinutes: $minimumDurationOfAKontestInMinutesKey
            )

            // Max Duration Slider
            MinutesSelectionSlider(
                message: "Select Max Duration of Kontest: \(getMessage(totalMinutes: Int(maximumDurationOfAKontestInMinutesKey)))",
                minimumMinutes: Double(Constants.minimumLimitOfMinutesOfKontest),
                maximumMinutes: Double(Constants.maximumLimitOfMinutesOfKontest),
                steps: 10,
                onEditingChanged: { _ in
                    if maximumDurationOfAKontestInMinutesKey < minimumDurationOfAKontestInMinutesKey {
                        minimumDurationOfAKontestInMinutesKey = maximumDurationOfAKontestInMinutesKey
                    }
                },
                currentMinutes: $maximumDurationOfAKontestInMinutesKey
            )
        }
        .padding()
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle("Filter Websites")
        .onDisappear {
            allKontestsViewModel.filterKontestsByTime()

            Task {
                await MainActor.run {
                    allKontestsViewModel.sortAllKontests()
                }

                allKontestsViewModel.addAllowedWebsites()
                allKontestsViewModel.filterKontests()
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }

    func getMessage(totalMinutes: Int) -> String {
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60

        return if minutes == 0 && hours == 0 {
            "0 minutes"
        }
        else if hours == 0 {
            "\(minutes) minutes"
        }
        else if hours == 1 && minutes == 0 {
            "1 hour"
        }

        else if hours == 1 {
            "1 hour & \(minutes) minutes"
        }
        else if minutes == 0 // hours != 0
        {
            "\(hours) hours"
        }
        else {
            "\(hours) hours & \(minutes) minutes"
        }
    }
}

struct MinutesSelectionSlider: View {
    let message: String
    let minimumMinutes: Double
    let maximumMinutes: Double
    let steps: Double
    let onEditingChanged: (Bool) -> ()
    @Binding var currentMinutes: Double

    var body: some View {
        VStack {
            Text(message)

            HStack {
                Text("\(Int(minimumMinutes)) minutes")

                Slider(value: $currentMinutes, in: minimumMinutes ... maximumMinutes, step: steps, onEditingChanged: {
                    isChanged in
                    onEditingChanged(isChanged)
                })

                Text("\(Int(maximumMinutes / 60)) hours")
            }
        }
    }
}

#Preview {
    NavigationStack {
        FilterWebsitesScreen()
            .frame(width: 500, height: 500)
    }
}
