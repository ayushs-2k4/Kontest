//
//  FilterWebsitesViewRegular.swift
//  Kontest
//
//  Created by Ayush Singhal on 09/09/23.
//

import SwiftUI

struct FilterWebsitesViewRegular: View {
    let siteLogo: Image
    let siteName: String
    let borderColor: Color
    let siteAbbreviation: String
    @Binding var isSelected: Bool

    let userDefaults = UserDefaults(suiteName: Constants.userDefaultsGroupID)!

    @State private var areAutomaticCalendarEventsEnabled: Bool

    init(siteLogo: Image, siteName: String, borderColor: Color, siteAbbreviation: String, isSelected: Binding<Bool>) {
        self.siteLogo = siteLogo
        self.siteName = siteName
        self.borderColor = borderColor
        self.siteAbbreviation = siteAbbreviation
        self._isSelected = isSelected
        self._areAutomaticCalendarEventsEnabled = State(initialValue: userDefaults.bool(forKey: siteAbbreviation + Constants.automaticCalendarEventSuffix))
    }

    var body: some View {
        Button {
            isSelected.toggle()
        } label: {
            HStack(alignment: .top) { // Use HStack for horizontal layout
                VStack(alignment: .leading) { // Use VStack for vertical layout
                    siteLogo
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                    Text(siteName)
                }

                Spacer()

                VStack {
                    Button {
                        let newKey = siteAbbreviation + Constants.automaticCalendarEventSuffix

                        if areAutomaticCalendarEventsEnabled {
                            userDefaults.setValue(false, forKey: newKey)
                        }
                        else {
                            userDefaults.setValue(true, forKey: newKey)
                        }

                        areAutomaticCalendarEventsEnabled = userDefaults.bool(forKey: siteAbbreviation + Constants.automaticCalendarEventSuffix)
                    } label: {
                        if areAutomaticCalendarEventsEnabled {
                            Image(systemName: "calendar.badge.minus")
                        }
                        else {
                            Image(systemName: "calendar.badge.plus")
                        }
                    }
                    .help(areAutomaticCalendarEventsEnabled ? "Disable automatic Calendar Events for \(siteName)" : "Enable automatic Calendar Events for \(siteName)")

                    Spacer()

//                    for automatic notifiactions
                    AutomaticNotificationMenu(siteAbbreviation: self.siteAbbreviation)
                        .frame(width: 45)
                }
            }
            .frame(maxWidth: .infinity)
            .aspectRatio(2.5, contentMode: .fit)
            .padding()
            .contentShape(
                RoundedRectangle(cornerRadius: 10)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? borderColor : borderColor.opacity(0), lineWidth: 2)
            )
            .padding(1)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    @State var isSelected: Bool = true

    return FilterWebsitesViewRegular(
        siteLogo: Image(.hackerRankLogo),
        siteName: "Hacker Rank",
        borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: "HackerRank"),
        siteAbbreviation: "HackerRank",
        isSelected: $isSelected
    )
}
