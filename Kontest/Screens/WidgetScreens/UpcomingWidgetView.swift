//
//  UpcomingWidgetView.swift
//  Kontest
//
//  Created by Ayush Singhal on 12/09/23.
//

import SwiftUI
import WidgetKit

struct UpcomingWidgetView: View {
    let error: Error?
    let isDataOld: Bool
    let toShowCalendarButton: Bool
    let allKontests: [KontestModel]
    let filteredKontests: [KontestModel]
    let ongoingKontests: [KontestModel]
    let laterTodayKontests: [KontestModel]
    let tomorrowKontests: [KontestModel]
    let laterKontests: [KontestModel]
    @Environment(\.widgetFamily) private var widgetFamily

    let userDefaults = UserDefaults(suiteName: Constants.userDefaultsGroupID)

    var body: some View {
        if let error = error {
            if let appError = error as? AppError {
                Text("Error: \(appError.title)")
            } else {
                Text("Error: \(error.localizedDescription)")
            }
        } else {
            if !allKontests.isEmpty && filteredKontests.isEmpty {
                Text("Change filters to see Kontests")
            } else if allKontests.isEmpty {
                Text("No Kontests Scheduled")
            } else {
                GeometryReader { geometry in
                    LazyVStack {
                        if isDataOld {
                            Text("Data is not updated")
                        }

                        if !ongoingKontests.isEmpty {
                            CreateSectionView(title: "Live Now", kontests: ongoingKontests, widgetFamily: widgetFamily, kontestStatus: .OnGoing, toShowCalendarButton: false)
                        }

                        if !laterTodayKontests.isEmpty {
                            CreateSectionView(title: "Later Today Kontests", kontests: laterTodayKontests, widgetFamily: widgetFamily, kontestStatus: .LaterToday, toShowCalendarButton: toShowCalendarButton)
                        }

                        if !tomorrowKontests.isEmpty {
                            CreateSectionView(title: "Tomorrow Kontests", kontests: tomorrowKontests, widgetFamily: widgetFamily, kontestStatus: .Tomorrow, toShowCalendarButton: toShowCalendarButton)
                        }

                        if !laterKontests.isEmpty {
                            CreateSectionView(title: "Later Kontests", kontests: laterKontests, widgetFamily: widgetFamily, kontestStatus: .Later, toShowCalendarButton: toShowCalendarButton)
                        }
                    }
                    .frame(height: geometry.size.height, alignment: .top)
                }
            }
        }
    }
}

struct CreateSectionView: View {
    let title: String
    let kontests: [KontestModel]
    let widgetFamily: WidgetFamily
    let kontestStatus: KontestStatus
    let toShowCalendarButton: Bool

    var body: some View {
        LazyVStack(alignment: .leading) {
            Text(title)
                .bold()

            ForEach(kontests.indices, id: \.self) { index in
                createSingleKontestView(kontest: kontests[index], widgetFamily: widgetFamily, kontestStatus: kontestStatus, toShowCalendarButton: toShowCalendarButton)
                if index != kontests.count - 1 {
                    Divider()
                }
            }

            Divider()
                .frame(minHeight: 2)
                .overlay(RoundedRectangle(cornerRadius: 10).fill(.gray))
        }
    }
}

struct createSingleKontestView: View {
    let kontest: KontestModel
    let widgetFamily: WidgetFamily
    let kontestStatus: KontestStatus
    let toShowCalendarButton: Bool

    @Environment(\.widgetRenderingMode) var widgetRenderingMode

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    var body: some View {
        let startDate = CalendarUtility.getDate(date: kontest.start_time)
        let endDate = CalendarUtility.getDate(date: kontest.end_time)

        if let startDate, let endDate {
            HStack {
                Text(kontest.name)
                    .foregroundStyle(kontest.siteAbbreviation == "AtCoder" ? Color.gray : kontest.siteAbbreviation == "TopCoder" ? .primary : KontestModel.getColorForIdentifier(siteAbbreviation: kontest.siteAbbreviation))

                Spacer()

                Group {
                    if kontestStatus == .OnGoing || kontestStatus == .LaterToday || kontestStatus == .Tomorrow {
                        HStack {
                            if widgetFamily == .systemExtraLarge {
                                if widgetRenderingMode == .fullColor {
                                    if kontestStatus == .OnGoing {
                                        let seconds = endDate.timeIntervalSince(Date())
                                        let futureDate = Calendar.current.date(byAdding: .second, value: Int(seconds), to: Date())!

                                        Text("Ends in: \(futureDate, style: .timer)")
                                            .fontDesign(.default).monospacedDigit()
                                            .multilineTextAlignment(.trailing)
                                    } else if toShowStartingIn {
                                        let seconds = startDate.timeIntervalSince(Date())
                                        let futureDate = Calendar.current.date(byAdding: .second, value: Int(seconds), to: Date())!

                                        Text("Starting in: \(futureDate, style: .timer)")
                                            .fontDesign(.default).monospacedDigit()
                                            .multilineTextAlignment(.trailing)
                                    }
                                } else {
                                    Text("")
                                }

                                HStack {
                                    Text(startDate.formatted(date: .omitted, time: .shortened))
                                    Text(" - ")
                                    Text(endDate.formatted(date: .omitted, time: .shortened))
                                }

                            } else if widgetFamily == .systemLarge {
                                Text(startDate.formatted(date: .omitted, time: .shortened))
                            }
                        }
                    }

                    if kontestStatus == .Later {
                        if widgetFamily == .systemExtraLarge {
                            let p = CalendarUtility.getWeekdayNameFromDate(date: startDate)
                            Text("(\(p))")
                        }

                        if widgetFamily == .systemExtraLarge {
                            Text(startDate.formatted(date: .abbreviated, time: .omitted))
                        } else if widgetFamily == .systemLarge {
                            Text(startDate.formatted(date: .numeric, time: .omitted))
                        }
                    }
                }
                
                .minimumScaleFactor(0.1)

                if toShowCalendarButton {
                    Toggle(isOn: kontest.isCalendarEventAdded, intent: AddToCalendarIntent(title: kontest.name, notes: "", startDate: startDate, endDate: endDate, url: URL(string: kontest.url), toRemove: kontest.isCalendarEventAdded)) {}
                        .toggleStyle(MyCustomToggleStyle(onColor: .green, offColor: .blue))
                } else {
                    Spacer()
                        .frame(width: 0, height: 30)
                }
            }
            .lineLimit(1)
            
            
        }
    }

    var toShowStartingIn: Bool {
        let kontestStartDate = CalendarUtility.getDate(date: kontest.start_time)
        let isKontestOfFuture = CalendarUtility.isKontestOfFuture(kontestStartDate: kontestStartDate ?? Date())
        let isKontestStartingTimeLessThanADay = !(CalendarUtility.isRemainingTimeGreaterThanGivenTime(date: kontestStartDate, minutes: 0, hours: 0, days: 1))

        return isKontestOfFuture && isKontestStartingTimeLessThanADay
    }
}

struct MyCustomToggleStyle: ToggleStyle {
    var onColor: Color
    var offColor: Color

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label

            ZStack {
                RoundedRectangle(cornerRadius: 25.0)
                    .frame(width: 50, height: 30)
                    .foregroundStyle(configuration.isOn ? onColor.opacity(0.25) : offColor.opacity(0.25))

                Image(systemName: configuration.isOn ? "calendar.badge.minus" : "calendar.badge.plus")
                    .foregroundStyle(configuration.isOn ? onColor : offColor)
            }
        }
    }
}
