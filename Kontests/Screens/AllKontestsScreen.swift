//
//  AllKontestsScreen.swift
//  Kontests
//
//  Created by Ayush Singhal on 12/08/23.
//

import SwiftUI

struct AllKontestsScreen: View {
    let allKontestsViewModel = AllKontestsViewModel()
    @State var showRemoveAllNotificationsAlert = false

    var body: some View {
        NavigationStack {
            ZStack {
                if allKontestsViewModel.allKontests.isEmpty {
                    ProgressView()
                }
                else {
                    List {
                        ForEach(allKontestsViewModel.allKontests) { kontest in
                            let kontestDuration = DateUtility.getFormattedDuration(fromSeconds: kontest.duration) ?? ""
                            let kontestEndDate = DateUtility.getDate(date: kontest.end_time)
                            let isKontestEnded = DateUtility.isKontestOfPast(kontestEndDate: kontestEndDate ?? Date())

                            if !kontestDuration.isEmpty && !isKontestEnded {
                                Link(destination: URL(string: kontest.url)!, label: {
                                    SingleKontentView(kontest: kontest)
                                })
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Kontests")
            .onAppear {
                NotificationManager.instance.setBadgeCountTo0()
            }
            .toolbar {
                Button {
                    showRemoveAllNotificationsAlert = true
                    NotificationManager.instance.removeAllPendingNotifications()
                } label: {
                    Image(systemName: "bell.slash")
                }
                .help("Remove All Notifications") // Tooltip text
                .alert("All Notifications Removed", isPresented: $showRemoveAllNotificationsAlert, actions: {})
            }
        }
    }
}

struct BlinkingDot: View {
    let color: Color

    @State private var isFaded = false

    var body: some View {
        Circle()
            .foregroundStyle(color)
            .opacity(isFaded ? 0.2 : 1)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                    isFaded = true
                }
            }
    }
}

struct SingleKontentView: View {
    let kontest: Kontest
    @State var showNotificationSetAlert = false

    var body: some View {
        let kontestType = KontestType.getKontestType(name: kontest.site)
        let kontestProperties = getKontestProperties(for: kontestType)

        let kontestStartDate = DateUtility.getDate(date: kontest.start_time)
        let kontestEndDate = DateUtility.getDate(date: kontest.end_time)

//        let calendarURL = CalendarUtility.generateCalendarURL(startDate: kontestStartDate, endDate: kontestEndDate)

        HStack(alignment: .center) {
            VStack {
//                Text(calendarURL)
//                Link(destination: URL(string: calendarURL)!, label: {
//                    Text("Add to Calendar")
//                })

                Image(kontestProperties.logo)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: FontUtility.getLogoSize())

                let isContestRunning = DateUtility.isWithinDateRange(startDate: kontestStartDate ?? Date(), endDate: kontestEndDate ?? Date()) || kontest.status == "CODING"

                if isContestRunning {
                    BlinkingDot(color: .green)
                        .frame(width: 10, height: 10)
                }
                else {
                    EmptyView()
                }
            }

            VStack(alignment: .leading) {
                Text(kontest.site.uppercased())
                    .foregroundStyle(kontestProperties.prominentColor)
                    .bold()

                Text(kontest.name)
            }

            #if !os(iOS)
                Button {
                    ClipboardUtility.copyToClipBoard(kontest.url)
                } label: {
                    Image(systemName: "link")
                }
                .buttonStyle(.borderedProminent)
                .help("Copy link")
            #endif

            Button {
                let notificationDate = DateUtility.getTimeBefore(originalDate: kontestStartDate ?? Date(), minutes: 0, hours: 0)

                NotificationManager.instance.shecduleCalendarNotifications(title: kontest.name, subtitle: kontest.site, body: "Kontest is on \(kontest.start_time)", date: notificationDate)

                NotificationManager.instance.getAllPendingNotifications()

                showNotificationSetAlert = true

//                NotificationManager.instance.shecduleIntervalNotifications()
            } label: {
                Image(systemName: "bell")
            }
            .buttonStyle(.borderedProminent)
            .help("Set notification for this contest")
            .alert("Notification set for: \(kontest.name)", isPresented: $showNotificationSetAlert, actions: {})

            Spacer()

            VStack {
                if kontestStartDate != nil && kontestEndDate != nil {
                    Text("\(kontestStartDate!.formatted(date: .omitted, time: .shortened)) - \(kontestEndDate!.formatted(date: .omitted, time: .shortened))")
                        .foregroundStyle(kontestProperties.prominentColor)
                        .font(.custom("timeFont", fixedSize: FontUtility.getTimeFontSize()))
                        .bold()

                    HStack {
                        Image(systemName: "clock")

                        Text(DateUtility.getFormattedDuration(fromSeconds: kontest.duration) ?? "")
                    }
                    .font(.custom("dateFont", fixedSize: FontUtility.getDateFontSize()))
                    .padding(.vertical, 5)

                    Text("\(kontestStartDate!.formatted(date: .abbreviated, time: .omitted)) - \(kontestEndDate!.formatted(date: .abbreviated, time: .omitted))")
                        .font(.custom("dateFont", fixedSize: FontUtility.getDateFontSize()))
                }
                else {
                    Text("No date provided")
                }
            }
            .font(.footnote)

            Image(systemName: "chevron.right")
        }
        .padding()
    }
}

#Preview {
    AllKontestsScreen()
}

#Preview("SingleKontentView") {
    List {
        SingleKontentView(kontest: Kontest(name: "ProjectEuler+", url: "https://hackerrank.com/contests/projecteuler", start_time: "2014-07-07T15:38:00.000Z", end_time: "2024-07-30T18:30:00.000Z", duration: "317616720.0", site: "HackerRank", in_24_hours: "No", status: "No"))

        SingleKontentView(kontest: Kontest(name: "1v1 Games by CodeChef", url: "https://www.codechef.com/GAMES", start_time: "2022-10-10 06:30:00 UTC", end_time: "2032-10-10 06:30:00 UTC", duration: "315619200.0", site: "CodeChef", in_24_hours: "No", status: "CODING"))

        SingleKontentView(kontest: Kontest(name: "Weekly Contest 358", url: "https://leetcode.com/contest/weekly-contest-358", start_time: "2023-08-13T02:30:00.000Z", end_time: "2023-08-13T04:00:00.000Z", duration: "5400", site: "LeetCode", in_24_hours: "Yes", status: "BEFORE"))

        SingleKontentView(kontest: Kontest(name: "Test Contest", url: "https://leetcode.com/contest/weekly-contest-358", start_time: "2023-08-13T02:30:00.000Z", end_time: "2023-08-13T05:00:00.000Z", duration: "1800", site: "LeetCode", in_24_hours: "Yes", status: "BEFORE"))

        SingleKontentView(kontest: Kontest(name: "Starters 100 (Date to be decided)", url: "https://www.codechef.com/START100", start_time: "2023-08-30 14:30:00 UTC", end_time: "2023-08-30 16:30:00 UTC", duration: "7200", site: "CodeChef", in_24_hours: "No", status: "BEFORE"))
    }
}

#Preview("BlinkingDot") {
    BlinkingDot(color: .green)
}
