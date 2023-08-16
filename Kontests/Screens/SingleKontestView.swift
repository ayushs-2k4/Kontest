//
//  SingleKontestView.swift
//  Kontests
//
//  Created by Ayush Singhal on 14/08/23.
//

import SwiftUI

struct SingleKontestView: View {
    let kontest: KontestModel
    @Environment(AllKontestsViewModel.self) private var allKontestsViewModel

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        let kontestStartDate = CalendarUtility.getDate(date: kontest.start_time)
        let kontestEndDate = CalendarUtility.getDate(date: kontest.end_time)

        HStack(alignment: .center) {
            VStack {
                #if os(macOS)
                Image(KontestModel.getLogo(site: kontest.site))
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: FontUtility.getLogoSize())
                #endif

                let isContestRunning = CalendarUtility.isKontestRunning(kontestStartDate: kontestStartDate ?? Date(), kontestEndDate: kontestEndDate ?? Date()) || kontest.status == .Running

                if isContestRunning {
                    BlinkingDotView(color: .green)
                        .frame(width: 10, height: 10)
                }
                else {
                    #if os(macOS)
                    EmptyView()
                    #else
                    BlinkingDotView(color: .clear)
                        .frame(width: 10, height: 10)
                    #endif
                }
            }
            .foregroundStyle(colorScheme == .light ? .black : .white)

            VStack(alignment: .leading) {
                Text(kontest.site.uppercased())
                    .foregroundStyle(KontestModel.getColorForIdentifier(site: kontest.site))
                    .bold()
                    .font(FontUtility.getSiteFontSize())

                Text(kontest.name)
                    .font(FontUtility.getNameFontSize())
                #if os(iOS)
                    .padding(.top, 1)
                    .lineLimit(1)
                #else
                    .multilineTextAlignment(.leading)
                #endif
            }
            .foregroundStyle(colorScheme == .light ? .black : .white)

            #if !os(iOS)
            Button {
                ClipboardUtility.copyToClipBoard(kontest.url)
            } label: {
                Image(systemName: "link")
            }
            .help("Copy link")
            #endif

            #if os(macOS)
            if CalendarUtility.isKontestOfFuture(kontestStartDate: kontestStartDate ?? Date()) {
                Button {
                    if kontest.isSetForReminder {
                        allKontestsViewModel.removePendingNotification(kontest: kontest)
                    }
                    else {
                        allKontestsViewModel.setNotification(kontest: kontest)
                    }

                } label: {
                    Image(systemName: kontest.isSetForReminder ? "bell.fill" : "bell")
                }
                .help(kontest.isSetForReminder ? "Remove notification for this contest" : "Set notification for this contest")
            }
            #endif

            Spacer()

            VStack {
                if kontestStartDate != nil && kontestEndDate != nil {
                    Text("\(kontestStartDate!.formatted(date: .omitted, time: .shortened)) - \(kontestEndDate!.formatted(date: .omitted, time: .shortened))")
                        .foregroundStyle(KontestModel.getColorForIdentifier(site: kontest.site))
                        .font(FontUtility.getTimeFontSize())
                        .bold()

                    HStack {
                        Image(systemName: "clock")

                        Text(CalendarUtility.getFormattedDuration(fromSeconds: kontest.duration) ?? "")
                    }
                    .font(FontUtility.getDateFontSize())
                    .padding(.vertical, 5)

                    Text("\(CalendarUtility.getNumericKontestDate(date: kontestStartDate ?? Date())) - \(CalendarUtility.getNumericKontestDate(date: kontestEndDate ?? Date()))")
                        .font(FontUtility.getDateFontSize())
                }
                else {
                    Text("No date provided")
                }
            }
            .foregroundStyle(colorScheme == .light ? .black : .white)
            .font(.footnote)

            #if os(macOS)
            Image(systemName: "chevron.right")
                .foregroundStyle(.gray)
            #endif
        }
        #if os(macOS)
        .padding()
        #endif
    }
}

#Preview("SingleKontentView") {
    let allKontestsViewModel = AllKontestsViewModel()

    return List {
        SingleKontestView(kontest: KontestModel.from(dto: KontestDTO(name: "ProjectEuler+", url: "https://hackerrank.com/contests/projecteuler", start_time: "2014-07-07T15:38:00.000Z", end_time: "2024-07-30T18:30:00.000Z", duration: "317616720.0", site: "HackerRank", in_24_hours: "No", status: "BEFORE")))
        SingleKontestView(kontest: KontestModel.from(dto: KontestDTO(name: "1v1 Games by CodeChef", url: "https://www.codechef.com/GAMES", start_time: "2022-10-10 06:30:00 UTC", end_time: "2032-10-10 06:30:00 UTC", duration: "315619200.0", site: "CodeChef", in_24_hours: "No", status: "CODING")))
        SingleKontestView(kontest: KontestModel.from(dto: KontestDTO(name: "Weekly Contest 358", url: "https://leetcode.com/contest/weekly-contest-358", start_time: "2023-08-13T02:30:00.000Z", end_time: "2023-08-13T04:00:00.000Z", duration: "5400", site: "LeetCode", in_24_hours: "Yes", status: "BEFORE")))

        SingleKontestView(kontest: KontestModel.from(dto: KontestDTO(name: "Test Contest", url: "https://leetcode.com/contest/weekly-contest-358", start_time: "2023-08-13T02:30:00.000Z", end_time: "2023-08-13T05:00:00.000Z", duration: "1800", site: "LeetCode", in_24_hours: "Yes", status: "BEFORE")))
        SingleKontestView(kontest: KontestModel.from(dto: KontestDTO(name: "Starters 100 (Date to be decided)", url: "https://www.codechef.com/START100", start_time: "2023-08-30 14:30:00 UTC", end_time: "2023-08-30 16:30:00 UTC", duration: "7200", site: "CodeChef", in_24_hours: "No", status: "BEFORE")))
    }
}
