//
//  FilterWebsitesViewCompact.swift
//  Kontest
//
//  Created by Ayush Singhal on 01/05/24.
//

import SwiftUI

struct FilterWebsitesViewCompact: View {
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
        HStack(alignment: .center) { // Use HStack for horizontal layout
            HStack {
                siteLogo
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 40)

                Text(siteName)

                Spacer()
            }
            .onTapGesture(perform: {
                isSelected.toggle()
            })

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

//                    // for automatic notifiactions
            AutomaticNotificationMenu(siteAbbreviation: self.siteAbbreviation)
                .frame(width: 45)
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(2, contentMode: .fit)
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
}

#Preview {
    @State var isSelected: Bool = true

    return FilterWebsitesViewCompact(
        siteLogo: Image(.hackerRankLogo),
        siteName: "Hacker Rank",
        borderColor: KontestModel.getColorForIdentifier(siteAbbreviation: "HackerRank"),
        siteAbbreviation: "HackerRank",
        isSelected: $isSelected
    )
}
