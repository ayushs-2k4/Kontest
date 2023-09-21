//
//  SingleKontestView.swift
//  Kontest
//
//  Created by Ayush Singhal on 14/08/23.
//

import Combine
import SwiftUI
import WidgetKit

struct SingleKontestView: View {
    let kontest: KontestModel
    let timelineViewDefaultContext: TimelineViewDefaultContext
    @Environment(AllKontestsViewModel.self) private var allKontestsViewModel
    @Environment(ErrorState.self) private var errorState
    @Environment(\.colorScheme) private var colorScheme

    let notificationsViewModel: NotificationsViewModel

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    let kontestStartDate: Date?
    let kontestEndDate: Date?

    let isKontestRunning: Bool
    let isKontestOfFutureAndStartingInLessThan24Hours: Bool

    init(kontest: KontestModel, timelineViewDefaultContext: TimelineViewDefaultContext) {
        self.kontest = kontest
        self.timelineViewDefaultContext = timelineViewDefaultContext
        kontestStartDate = CalendarUtility.getDate(date: kontest.start_time)
        kontestEndDate = CalendarUtility.getDate(date: kontest.end_time)
        isKontestRunning = CalendarUtility.isKontestRunning(kontestStartDate: kontestStartDate ?? Date(), kontestEndDate: kontestEndDate ?? Date()) || kontest.status == .OnGoing
        let isKontestOfFuture = CalendarUtility.isKontestOfFuture(kontestStartDate: kontestStartDate ?? Date())
        let isKontestStartingTimeLessThanADay = !(CalendarUtility.isRemainingTimeGreaterThanGivenTime(date: kontestStartDate, minutes: 0, hours: 0, days: 1))
        isKontestOfFutureAndStartingInLessThan24Hours = isKontestOfFuture && isKontestStartingTimeLessThanADay

        notificationsViewModel = Dependencies.instance.notificationsViewModel
    }

    var body: some View {
        HStack(alignment: .center) {
            VStack {
                #if os(macOS)
                Image(KontestModel.getLogo(site: kontest.site))
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: FontUtility.getLogoSize())
                #endif

                #if !os(iOS)
                if isKontestRunning {
                    BlinkingDotView(color: .green)
                        .frame(width: 10, height: 10)
                }
                else {
                    EmptyView()
                }
                #endif
            }
            .foregroundStyle(colorScheme == .light ? .black : .white)

            VStack(alignment: .leading) {
                HStack {
                    Text(kontest.site.uppercased())
                        .foregroundStyle(KontestModel.getColorForIdentifier(site: kontest.site))
                        .bold()
                        .font(FontUtility.getSiteFontSize())

                    #if os(iOS)
                    if isKontestRunning {
                        BlinkingDotView(color: .green)
                            .frame(width: 10, height: 10)
                    }
                    #endif
                }

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

            if !isKontestRunning {
                Button {
                    if kontest.isCalendarEventAdded {
                        Task {
                            do {
                                try await CalendarUtility.removeEvent(startDate: kontestStartDate ?? Date(), endDate: kontestEndDate ?? Date(), title: kontest.name, notes: "", url: URL(string: kontest.url))

                                kontest.isCalendarEventAdded = false
                            }
                            catch {
                                errorState.errorWrapper = ErrorWrapper(error: error, guidance: "Check that you have given Kontest the Calendar Permission (Full Access)")
                            }
                        }
                    }
                    else {
                        Task {
                            do {
                                if try await CalendarUtility.addEvent(startDate: kontestStartDate ?? Date(), endDate: kontestEndDate ?? Date(), title: kontest.name, notes: "", url: URL(string: kontest.url)) {
                                    kontest.isCalendarEventAdded = true
                                }
                            }
                            catch {
                                errorState.errorWrapper = ErrorWrapper(error: error, guidance: "")
                            }
                        }
                    }

                    WidgetCenter.shared.reloadAllTimelines()
                } label: {
                    Image(systemName: kontest.isCalendarEventAdded ? "calendar.badge.minus" : "calendar.badge.plus")
                        .contentTransition(.symbolEffect(.replace.upUp))
                        .frame(width: 20)
                }
                .help(kontest.isCalendarEventAdded ? "Remove from Calendar" : "Add to Calendar")
            }
            #endif

            #if os(macOS)
            if CalendarUtility.isKontestOfFuture(kontestStartDate: kontestStartDate ?? Date()), notificationsViewModel.getNumberOfNotificationsWhichCanBeSettedForAKontest(kontest: kontest) > 0 {
                SingleNotificationMenu(kontest: kontest)
                    .frame(width: 45)
            }
            #endif

            Spacer()

            VStack {
                if kontestStartDate != nil && kontestEndDate != nil {
                    Text("\(kontestStartDate!.formatted(date: .omitted, time: .shortened)) - \(kontestEndDate!.formatted(date: .omitted, time: .shortened))")
                        .foregroundStyle(KontestModel.getColorForIdentifier(site: kontest.site))
                        .font(FontUtility.getTimeFontSize())
                        .bold()

                    VStack {
                        if isKontestRunning {
                            let date = timelineViewDefaultContext.date
                            let seconds = (kontestEndDate ?? Date()).timeIntervalSince(date)

                            #if os(iOS)
                            let remainingTimeInEndingOfRunningKontest = CalendarUtility.shortenedFormattedTimeFrom(seconds: Int(seconds))
                            #else
                            let remainingTimeInEndingOfRunningKontest = CalendarUtility.formattedTimeFrom(seconds: Int(seconds))
                            #endif

                            Text("Ends in \(remainingTimeInEndingOfRunningKontest)")
                                .font(FontUtility.getRemainingTimeFontSize().monospacedDigit())
                                .contentTransition(.numericText())
                                .animation(.easeInOut, value: remainingTimeInEndingOfRunningKontest)
                        }

                        if isKontestOfFutureAndStartingInLessThan24Hours {
                            let date = timelineViewDefaultContext.date
                            let seconds = (kontestStartDate ?? Date()).timeIntervalSince(date)

                            let remainingTimeInStartingOfFutureKontest = CalendarUtility.formattedTimeFrom(seconds: Int(seconds))

                            Text("Starting in \(remainingTimeInStartingOfFutureKontest)")
                                .font(FontUtility.getRemainingTimeFontSize().monospacedDigit())
                                .contentTransition(.numericText())
                                .animation(.easeInOut, value: remainingTimeInStartingOfFutureKontest)
                        }

                        HStack {
                            Image(systemName: "clock")

                            Text(CalendarUtility.getFormattedDuration(fromSeconds: kontest.duration) ?? "")
                        }
                        .font(FontUtility.getDateFontSize())
                    }
                    .padding(.vertical, 5)

                    #if os(macOS)
                    Text("\(CalendarUtility.getNumericKontestDate(date: kontestStartDate ?? Date())) (\(CalendarUtility.getWeekdayNameFromDate(date: kontestStartDate ?? Date()))) - \(CalendarUtility.getNumericKontestDate(date: kontestEndDate ?? Date())) (\(CalendarUtility.getWeekdayNameFromDate(date: kontestEndDate ?? Date())))")
                        .font(FontUtility.getDateFontSize())
                    #else
                    Text("\(CalendarUtility.getNumericKontestDate(date: kontestStartDate ?? Date())) - \(CalendarUtility.getNumericKontestDate(date: kontestEndDate ?? Date()))")
                    #endif
                }
                else {
                    Text("No date provided")
                }
            }
            .foregroundStyle(colorScheme == .light ? .black : .white)
            .font(.footnote)
        }
        #if os(macOS)
        .padding()
        #endif
    }
}

#Preview("SingleKontentView") {
    let allKontestsViewModel = Dependencies.instance.allKontestsViewModel

    return List {
        TimelineView(.periodic(from: .now, by: 1)) { timelineViewDefaultContext in
            SingleKontestView(kontest: KontestModel.from(dto: KontestDTO(name: "ProjectEuler+", url: "https://hackerrank.com/contests/projecteuler", start_time: "2014-07-07T15:38:00.000Z", end_time: "2024-07-30T18:30:00.000Z", duration: "317616720.0", site: "HackerRank", in_24_hours: "No", status: "BEFORE")), timelineViewDefaultContext: timelineViewDefaultContext)
        }

        TimelineView(.periodic(from: .now, by: 1)) { timelineViewDefaultContext in
            SingleKontestView(kontest: KontestModel.from(dto: KontestDTO(name: "1v1 Games by CodeChef", url: "https://www.codechef.com/GAMES", start_time: "2023-8-27 12:30:00 UTC", end_time: "2032-11-10 06:30:00 UTC", duration: "315619200.0", site: "CodeChef", in_24_hours: "No", status: "CODING")), timelineViewDefaultContext: timelineViewDefaultContext)
        }

        TimelineView(.periodic(from: .now, by: 1)) { timelineViewDefaultContext in
            SingleKontestView(kontest: KontestModel.from(dto: KontestDTO(name: "Weekly Contest 358", url: "https://leetcode.com/contest/weekly-contest-358", start_time: "2023-09-03T02:30:00.000Z", end_time: "2023-10-25T04:00:00.000Z", duration: "5400", site: "LeetCode", in_24_hours: "Yes", status: "BEFORE")), timelineViewDefaultContext: timelineViewDefaultContext)
        }

        TimelineView(.periodic(from: .now, by: 1)) { timelineViewDefaultContext in
            SingleKontestView(kontest: KontestModel.from(dto: KontestDTO(name: "Test Contest", url: "https://leetcode.com/contest/weekly-contest-358", start_time: "2023-08-13T02:30:00.000Z", end_time: "2023-08-13T05:00:00.000Z", duration: "1800", site: "LeetCode", in_24_hours: "Yes", status: "BEFORE")), timelineViewDefaultContext: timelineViewDefaultContext)
        }

        TimelineView(.periodic(from: .now, by: 1)) { timelineViewDefaultContext in
            SingleKontestView(kontest: KontestModel.from(dto: KontestDTO(name: "Starters 100 (Date to be decided)", url: "https://www.codechef.com/START100", start_time: "2023-08-30 14:30:00 UTC", end_time: "2023-08-30 16:30:00 UTC", duration: "7200", site: "CodeChef", in_24_hours: "No", status: "BEFORE")), timelineViewDefaultContext: timelineViewDefaultContext)
        }
    }
    .environment(allKontestsViewModel)

//    return SingleKontestView(kontest: KontestModel.from(dto: KontestDTO(name: "1v1 Games by CodeChef", url: "https://www.codechef.com/GAMES", start_time: "2023-11-10 06:30:00 UTC", end_time: "2032-11-10 06:30:00 UTC", duration: "315619200.0", site: "CodeChef", in_24_hours: "No", status: "CODING")))
//        .environment(allKontestsViewModel)
}
