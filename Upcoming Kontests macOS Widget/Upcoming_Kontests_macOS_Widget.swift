//
//  Upcoming_Kontests_macOS_Widget.swift
//  Upcoming Kontests macOS Widget
//
//  Created by Ayush Singhal on 12/09/23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct Upcoming_Kontests_macOS_WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            HStack {
                Text("Time:")
                Text(entry.date, style: .time)
            }

            Text("Emoji:")
            Text(entry.emoji)
        }
    }
}

struct Upcoming_Kontests_macOS_Widget: Widget {
    let kind: String = "Upcoming_Kontests_macOS_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(macOS 14.0, *) {
                Upcoming_Kontests_macOS_WidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                Upcoming_Kontests_macOS_WidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}
