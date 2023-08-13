//
//  AllKontestsScreen.swift
//  Kontests
//
//  Created by Ayush Singhal on 12/08/23.
//

import SwiftUI

struct AllKontestsScreen: View {
    let allKontestsViewModel = AllKontestsViewModel.instance
    @State var showRemoveAllNotificationsAlert = false
    @State var showNotificationForAllKontestsAlert = false

    var body: some View {
        NavigationStack {
            ZStack {
                if allKontestsViewModel.allKontests.isEmpty {
                    ProgressView()
                }
                else {
                    List {
                        ForEach(allKontestsViewModel.allKontests) { kontest in
                            Link(destination: URL(string: kontest.url)!, label: {
                                SingleKontentView(kontest: kontest, allKontestViewModel: allKontestsViewModel)
                            })
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .navigationTitle("Kontests")
            .onAppear {
                NotificationManager.instance.setBadgeCountTo0()
            }
            .toolbar {
//                Button {
//                    allKontestsViewModel.getAllPendingNotifications()
//                } label: {
//                    Text("Print all notifs")
//                }

                Button {
                    showNotificationForAllKontestsAlert = true
                    allKontestsViewModel.setNotificationForAllKontests()
//                    allKontestsViewModel.getAllPendingNotifications()
                } label: {
                    Image(systemName: "bell.fill")
                }
                .help("Set Notification for all following kontests") // Tooltip text
                .alert("Notification for all Kontests set.", isPresented: $showNotificationForAllKontestsAlert, actions: {})

                Button {
                    showRemoveAllNotificationsAlert = true
                    allKontestsViewModel.removeAllPendingNotifications()
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
    var kontest: KontestModel
    let allKontestViewModel: AllKontestsViewModel
    @State var showNotificationSetAlert = false

    var body: some View {
        let kontestStartDate = DateUtility.getDate(date: kontest.start_time)
        let kontestEndDate = DateUtility.getDate(date: kontest.end_time)

//        let calendarURL = CalendarUtility.generateCalendarURL(startDate: kontestStartDate, endDate: kontestEndDate)

        HStack(alignment: .center) {
            VStack {
//                Text(calendarURL)
//                Link(destination: URL(string: calendarURL)!, label: {
//                    Text("Add to Calendar")
//                })

                Image(KontestModel.getLogo(site: kontest.site))
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
                    .foregroundStyle(KontestModel.getColorForIdentifier(site: kontest.site))
                    .bold()

                Text(kontest.name)
            }

            #if !os(iOS)
                Button {
                    ClipboardUtility.copyToClipBoard(kontest.url)
                } label: {
                    Image(systemName: "link")
                }
                .help("Copy link")
            #endif

            if DateUtility.isKontestOfFuture(kontestStartDate: kontestStartDate ?? Date()) {
                Button {
                    if kontest.isSetForReminder {
                        allKontestViewModel.removePendingNotification(kontest: kontest)
                        allKontestViewModel.updateIsSetForNotification(kontest: kontest, to: false)
                    }
                    else {
                        allKontestViewModel.setNotification(kontest: kontest)
                        allKontestViewModel.updateIsSetForNotification(kontest: kontest, to: true)
                    }

                    showNotificationSetAlert = true

                } label: {
                    Image(systemName: kontest.isSetForReminder ? "bell.fill" : "bell")
                }
                .help("Set notification for this contest")
                .alert(kontest.isSetForReminder ? "Notification set for: \(kontest.name)" : "Notification cancelled for: \(kontest.name)", isPresented: $showNotificationSetAlert, actions: {})
            }

            Spacer()

            VStack {
                if kontestStartDate != nil && kontestEndDate != nil {
                    Text("\(kontestStartDate!.formatted(date: .omitted, time: .shortened)) - \(kontestEndDate!.formatted(date: .omitted, time: .shortened))")
                        .foregroundStyle(KontestModel.getColorForIdentifier(site: kontest.site))
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
        #if os(macOS)
        .padding()
        #endif
    }
}

#Preview {
    AllKontestsScreen()
}

#Preview("SingleKontentView") {
    let allKontestViewModel = AllKontestsViewModel.instance

    return List {
        SingleKontentView(kontest: KontestModel.from(dto: KontestDTO(name: "ProjectEuler+", url: "https://hackerrank.com/contests/projecteuler", start_time: "2014-07-07T15:38:00.000Z", end_time: "2024-07-30T18:30:00.000Z", duration: "317616720.0", site: "HackerRank", in_24_hours: "No", status: "No")), allKontestViewModel: allKontestViewModel)

        SingleKontentView(kontest: KontestModel.from(dto: KontestDTO(name: "1v1 Games by CodeChef", url: "https://www.codechef.com/GAMES", start_time: "2022-10-10 06:30:00 UTC", end_time: "2032-10-10 06:30:00 UTC", duration: "315619200.0", site: "CodeChef", in_24_hours: "No", status: "CODING")), allKontestViewModel: allKontestViewModel)

        SingleKontentView(kontest: KontestModel.from(dto: KontestDTO(name: "Weekly Contest 358", url: "https://leetcode.com/contest/weekly-contest-358", start_time: "2023-08-13T02:30:00.000Z", end_time: "2023-08-13T04:00:00.000Z", duration: "5400", site: "LeetCode", in_24_hours: "Yes", status: "BEFORE")), allKontestViewModel: allKontestViewModel)

        SingleKontentView(kontest: KontestModel.from(dto: KontestDTO(name: "Test Contest", url: "https://leetcode.com/contest/weekly-contest-358", start_time: "2023-08-13T02:30:00.000Z", end_time: "2023-08-13T05:00:00.000Z", duration: "1800", site: "LeetCode", in_24_hours: "Yes", status: "BEFORE")), allKontestViewModel: allKontestViewModel)

        SingleKontentView(kontest: KontestModel.from(dto: KontestDTO(name: "Starters 100 (Date to be decided)", url: "https://www.codechef.com/START100", start_time: "2023-08-30 14:30:00 UTC", end_time: "2023-08-30 16:30:00 UTC", duration: "7200", site: "CodeChef", in_24_hours: "No", status: "BEFORE")), allKontestViewModel: allKontestViewModel)
    }
}

#Preview("BlinkingDot") {
    BlinkingDot(color: .green)
}
