//
//  Upcoming_Kontests_iOS_Widget.swift
//  Upcoming Kontests iOS Widget
//
//  Created by Ayush Singhal on 12/09/23.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    let kontestModel = KontestModel.from(dto: KontestDTO(name: "ProjectEuler+1", url: "https://hackerrank.com/contests/projecteuler", start_time: "2023-08-15 18:29:00 UTC", end_time: "2023-08-18 17:43:00 UTC", duration: "1020.0", site: "HackerRank", in_24_hours: "No", status: "BEFORE"))

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), error: nil, ongoingKontests: [], laterTodayKontests: [], tomorrowKontests: [], laterKontests: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), error: nil, ongoingKontests: [kontestModel], laterTodayKontests: [], tomorrowKontests: [], laterKontests: [])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let today = Date()
        let tomorrow = CalendarUtility.getTomorrow()
        let dayAfterTomorrow = CalendarUtility.getDayAfterTomorrow()

        Task {
            let allKontestsWithError = await GetKontests.getKontests()
            let allKontests = allKontestsWithError.fetchedKontests
            let error = allKontestsWithError.error

            let ongoingKontests = allKontests.filter { CalendarUtility.isKontestRunning(kontestStartDate: CalendarUtility.getDate(date: $0.start_time) ?? today, kontestEndDate: CalendarUtility.getDate(date: $0.end_time) ?? today) }

            let laterTodayKontests = allKontests.filter {
                CalendarUtility.getDate(date: $0.start_time) ?? today < tomorrow && !(ongoingKontests.contains($0))
            }

            let tomorrowKontests = allKontests.filter { (CalendarUtility.getDate(date: $0.start_time) ?? today >= tomorrow) && (CalendarUtility.getDate(date: $0.start_time) ?? today < dayAfterTomorrow) }

            let laterKontests = allKontests.filter {
                CalendarUtility.getDate(date: $0.start_time) ?? today >= dayAfterTomorrow
            }

            var myEntries: [SimpleEntry] = []

            let entry = SimpleEntry(date: Date(), error: error, ongoingKontests: ongoingKontests, laterTodayKontests: laterTodayKontests, tomorrowKontests: tomorrowKontests, laterKontests: laterKontests)

            myEntries.append(entry)

            let timeline = Timeline(entries: myEntries, policy: .atEnd)
            completion(timeline)
        }
    }

   
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let error: Error?
    let ongoingKontests: [KontestModel]
    let laterTodayKontests: [KontestModel]
    let tomorrowKontests: [KontestModel]
    let laterKontests: [KontestModel]
}

struct Upcoming_Kontests_iOS_WidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            if let error = entry.error {
                Text("Error: \(error.localizedDescription)")
            } else {
                if !entry.ongoingKontests.isEmpty {
                    CreateSectionView(title: "On Going Kontests", kontests: entry.ongoingKontests, toShowDate: false, toShowTime: false)
                }

                if !entry.laterTodayKontests.isEmpty {
                    CreateSectionView(title: "Later Today Kontests", kontests: entry.laterTodayKontests, toShowDate: false, toShowTime: true)
                }

                if !entry.tomorrowKontests.isEmpty {
                    CreateSectionView(title: "Tomorrow Kontests", kontests: entry.tomorrowKontests, toShowDate: false, toShowTime: true)
                }

                if !entry.laterKontests.isEmpty {
                    CreateSectionView(title: "Later Kontests", kontests: entry.laterKontests, toShowDate: true, toShowTime: false)
                }
            }
        }
    }
}

struct Upcoming_Kontests_iOS_Widget: Widget {
    let kind: String = "Upcoming_Kontests_iOS_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                Upcoming_Kontests_iOS_WidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                Upcoming_Kontests_iOS_WidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .supportedFamilies([.systemLarge, .systemExtraLarge])
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemLarge) {
    Upcoming_Kontests_iOS_Widget()
} timeline: {
    let kontestModel = KontestModel.from(dto: KontestDTO(name: "ProjectEuler+1indsjjns,xd", url: "https://hackerrank.com/contests/projecteuler", start_time: "2023-08-15 18:29:00 UTC", end_time: "2023-08-18 17:43:00 UTC", duration: "1020.0", site: "HackerRank", in_24_hours: "No", status: "BEFORE"))

    SimpleEntry(date: .now, error: nil, ongoingKontests: [kontestModel], laterTodayKontests: [kontestModel], tomorrowKontests: [kontestModel, kontestModel], laterKontests: [kontestModel])
}
