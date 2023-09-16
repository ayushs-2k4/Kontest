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
    let ongoingKontests: [KontestModel]
    let laterTodayKontests: [KontestModel]
    let tomorrowKontests: [KontestModel]
    let laterKontests: [KontestModel]
    @Environment(\.widgetFamily) private var widgetFamily

    var body: some View {
        VStack {
            if let error = error {
                if let appError = error as? AppError {
                    Text("Error: \(appError.title)")
                } else {
                    Text("Error: \(error.localizedDescription)")
                }
            } else {
                if ongoingKontests.isEmpty && laterTodayKontests.isEmpty && tomorrowKontests.isEmpty && laterKontests.isEmpty {
                    Text("No Kontests Scheduled")
                } else {
                    if !ongoingKontests.isEmpty {
                        CreateSectionView(title: "Live Now", kontests: ongoingKontests, widgetFamily: widgetFamily, kontestStatus: .OnGoing)
                    }

                    if !laterTodayKontests.isEmpty {
                        CreateSectionView(title: "Later Today Kontests", kontests: laterTodayKontests, widgetFamily: widgetFamily, kontestStatus: .LaterToday)
                    }

                    if !tomorrowKontests.isEmpty {
                        CreateSectionView(title: "Tomorrow Kontests", kontests: tomorrowKontests, widgetFamily: widgetFamily, kontestStatus: .Tomorrow)
                    }

                    if !laterKontests.isEmpty {
                        CreateSectionView(title: "Later Kontests", kontests: laterKontests, widgetFamily: widgetFamily, kontestStatus: .Later)
                    }
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

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .bold()

            ForEach(kontests.indices, id: \.self) { index in
                createSingleKontestView(kontest: kontests[index], widgetFamily: widgetFamily, kontestStatus: kontestStatus)
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

    var body: some View {
        let startDate = CalendarUtility.getDate(date: kontest.start_time)
        let endDate = CalendarUtility.getDate(date: kontest.end_time)

        if let startDate, let endDate {
            HStack {
                Text(kontest.name)
                    .foregroundStyle(kontest.site == "AtCoder" ? Color.gray : KontestModel.getColorForIdentifier(site: kontest.site))

                Spacer()

                Group {
                    if kontestStatus == .OnGoing || kontestStatus == .LaterToday || kontestStatus == .Tomorrow {
                        if widgetFamily == .systemExtraLarge {
                            HStack {
                                Text(startDate.formatted(date: .omitted, time: .shortened))
                                Text(" - ")
                                Text(endDate.formatted(date: .omitted, time: .shortened))
                            }
                        } else {
                            Text(startDate.formatted(date: .omitted, time: .shortened))
                        }
                    }

                    if kontestStatus == .Later {
                        if widgetFamily == .systemExtraLarge {
                            let p = CalendarUtility.getWeekdayNameFromDate(date: startDate)
                            Text("(\(p))")
                        }
                        Text(CalendarUtility.getKontestDate(date: startDate))
                    }
                }

                Button(intent: AddToCalendarIntent(title: kontest.name, notes: "", startDate: startDate, endDate: endDate, url: URL(string: kontest.url), toRemove: kontest.isCalendarEventAdded)) {
                    Image(systemName: kontest.isCalendarEventAdded ? "calendar.badge.minus" : "calendar.badge.plus")
                }
            }
        }
    }
}
