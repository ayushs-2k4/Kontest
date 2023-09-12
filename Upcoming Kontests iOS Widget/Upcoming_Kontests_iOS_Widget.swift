//
//  Upcoming_Kontests_iOS_Widget.swift
//  Upcoming Kontests iOS Widget
//
//  Created by Ayush Singhal on 12/09/23.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀", allKontests: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀", allKontests: [])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        //        let currentDate = Date()
        //        for hourOffset in 0 ..< 5 {
        //            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
        //            let entry = SimpleEntry(date: entryDate, emoji: "😀", allKontests: [])
        //            entries.append(entry)
        //        }

        Task {
            let allKontests = await fetchKontests()

            var myEntries: [SimpleEntry] = []
            let entry = SimpleEntry(date: Date(), emoji: "😀", allKontests: allKontests)
            myEntries.append(entry)

            let timeline = Timeline(entries: myEntries, policy: .atEnd)
            completion(timeline)
        }
    }

    private func fetchKontests() async -> [KontestModel] {
        let repository = KontestRepository()

        do {
            let fetchedKontests = try await repository.getAllKontests()

            return fetchedKontests
                .map { dto in
                    let kontest = KontestModel.from(dto: dto)
                    // Load Reminder status
                    kontest.loadReminderStatus()
                    return kontest
                }
                .filter { kontest in
                    let kontestDuration = CalendarUtility.getFormattedDuration(fromSeconds: kontest.duration) ?? ""
                    let kontestEndDate = CalendarUtility.getDate(date: kontest.end_time)
                    let isKontestEnded = CalendarUtility.isKontestOfPast(kontestEndDate: kontestEndDate ?? Date())

                    return !kontestDuration.isEmpty && !isKontestEnded
                }
        } catch {
            print("error in fetching all Kontests: \(error)")
            return []
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
    let allKontests: [KontestModel]
}

struct Upcoming_Kontests_iOS_WidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

            Text("Emoji:")
            Text(entry.emoji)

            Text("Kons: \(entry.allKontests.count)")
            ForEach(entry.allKontests) { kon in
                Text(kon.name)
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
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    Upcoming_Kontests_iOS_Widget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀", allKontests: [])
    SimpleEntry(date: .now, emoji: "🤩", allKontests: [])
}
