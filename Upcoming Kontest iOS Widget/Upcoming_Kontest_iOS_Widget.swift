//
//  Upcoming_Kontest_iOS_Widget.swift
//  Upcoming Kontest iOS Widget
//
//  Created by Ayush Singhal on 21/09/23.
//

import SwiftUI
import UserNotifications
import WidgetKit

struct Provider: TimelineProvider {
    let kontestModel = KontestModel.from(
        dto: KontestDTO(
            name: "ProjectEuler+1",
            url: "https://hackerrank.com/contests/projecteuler",
            start_time: "2023-08-15 18:29:00 UTC",
            end_time: "2023-08-18 17:43:00 UTC",
            duration: "1020.0",
            site: "HackerRank",
            in_24_hours: "No",
            status: "BEFORE"
        )
    )

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            error: nil,
            allKontests: [kontestModel],
            filteredKontests: [kontestModel],
            ongoingKontests: [kontestModel],
            laterTodayKontests: [kontestModel],
            tomorrowKontests: [kontestModel],
            laterKontests: [kontestModel]
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let networkMonitor = NetworkMonitor.shared
        networkMonitor.start()

        if networkMonitor.currentStatus == .satisfied {
            Task {
                let kontestsDividedInCategories = await GetKontests.getKontestsDividedIncategories()

                let entry = SimpleEntry(
                    date: Date(),
                    error: kontestsDividedInCategories.error,
                    allKontests: kontestsDividedInCategories.allKontests,
                    filteredKontests: kontestsDividedInCategories.filteredKontests,
                    ongoingKontests: kontestsDividedInCategories.ongoingKontests,
                    laterTodayKontests: kontestsDividedInCategories.laterTodayKontests,
                    tomorrowKontests: kontestsDividedInCategories.tomorrowKontests,
                    laterKontests: kontestsDividedInCategories.laterKontests
                )

                completion(entry)
            }
        } else {
            let entry = SimpleEntry(
                date: Date(),
                error: AppError(title: "No Internet Connection", description: "Connect to Internet"),
                allKontests: [],
                filteredKontests: [],
                ongoingKontests: [],
                laterTodayKontests: [],
                tomorrowKontests: [],
                laterKontests: []
            )

            completion(entry)
        }

        networkMonitor.stop()
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let upcomingKontestsWidgetCache = UpcomingKontestsWidgetCache()

        let networkMonitor = NetworkMonitor.shared
        networkMonitor.start()

        if networkMonitor.currentStatus == .satisfied {
            print("Internet YES")
            Task {
                let kontestsDividedInCategories = await GetKontests.getKontestsDividedIncategories()

                let nextDateToRefresh = CalendarUtility.getNextDateToRefresh(
                    ongoingKontests: kontestsDividedInCategories.ongoingKontests,
                    laterTodayKontests: kontestsDividedInCategories.laterTodayKontests,
                    tomorrowKontests: kontestsDividedInCategories.tomorrowKontests,
                    laterKontests: kontestsDividedInCategories.laterKontests
                )

                var myEntries: [SimpleEntry] = []

                let entry = SimpleEntry(
                    date: nextDateToRefresh,
                    error: kontestsDividedInCategories.error,
                    allKontests: kontestsDividedInCategories.allKontests,
                    filteredKontests: kontestsDividedInCategories.filteredKontests,
                    ongoingKontests: kontestsDividedInCategories.ongoingKontests,
                    laterTodayKontests: kontestsDividedInCategories.laterTodayKontests,
                    tomorrowKontests: kontestsDividedInCategories.tomorrowKontests,
                    laterKontests: kontestsDividedInCategories.laterKontests
                )

                myEntries.append(entry)
                upcomingKontestsWidgetCache.storeNewEntry(entry)

                let timeline = Timeline(entries: myEntries, policy: .after(nextDateToRefresh))
                networkMonitor.stop()
                completion(timeline)
            }
        } else {
            var myEntries: [SimpleEntry] = []

            if var entry = upcomingKontestsWidgetCache.newEntryFromPrevious(withDate: Date()) {
                entry.isDataOld = true
                myEntries.append(entry)
            } else {
                let entry = SimpleEntry(
                    date: Date(),
                    error: AppError(title: "No Internet Connection", description: "Connect to Internet"),
                    allKontests: [],
                    filteredKontests: [],
                    ongoingKontests: [],
                    laterTodayKontests: [],
                    tomorrowKontests: [],
                    laterKontests: []
                )
                myEntries.append(entry)
            }

            let timeline = Timeline(entries: myEntries, policy: .after(.now.advanced(by: 0.5 * 60 * 60)))
            networkMonitor.stop()
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry, Codable {
    let date: Date
    let error: Error?
    var isDataOld = false
    let allKontests: [KontestModel]
    let filteredKontests: [KontestModel]
    let ongoingKontests: [KontestModel]
    let laterTodayKontests: [KontestModel]
    let tomorrowKontests: [KontestModel]
    let laterKontests: [KontestModel]

    enum CodingKeys: CodingKey {
        case date
        case allKontests
        case filteredKontests
        case ongoingKontests
        case laterTodayKontests
        case tomorrowKontests
        case laterKontests
    }

    init(date: Date, error: Error?, allKontests: [KontestModel], filteredKontests: [KontestModel], ongoingKontests: [KontestModel], laterTodayKontests: [KontestModel], tomorrowKontests: [KontestModel], laterKontests: [KontestModel]) {
        self.date = date
        self.error = error
        self.allKontests = allKontests
        self.filteredKontests = filteredKontests
        self.ongoingKontests = ongoingKontests
        self.laterTodayKontests = laterTodayKontests
        self.tomorrowKontests = tomorrowKontests
        self.laterKontests = laterKontests
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(Date.self, forKey: .date)
        error = nil
        allKontests = try container.decode([KontestModel].self, forKey: .allKontests)
        filteredKontests = try container.decode([KontestModel].self, forKey: .filteredKontests)
        ongoingKontests = try container.decode([KontestModel].self, forKey: .ongoingKontests)
        laterTodayKontests = try container.decode([KontestModel].self, forKey: .laterTodayKontests)
        tomorrowKontests = try container.decode([KontestModel].self, forKey: .tomorrowKontests)
        laterKontests = try container.decode([KontestModel].self, forKey: .laterKontests)
    }
}

struct Upcoming_Kontests_iOS_WidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        UpcomingWidgetView(
            error: entry.error,
            isDataOld: entry.isDataOld,
            toShowCalendarButton: CalendarUtility.getAuthorizationStatus() == .fullAccess,
            allKontests: entry.allKontests,
            filteredKontests: entry.filteredKontests,
            ongoingKontests: entry.ongoingKontests,
            laterTodayKontests: entry.laterTodayKontests,
            tomorrowKontests: entry.tomorrowKontests,
            laterKontests: entry.laterKontests
        )
    }
}

struct Upcoming_Kontest_iOS_Widget: Widget {
    let kind: String = "Upcoming_Kontests_iOS_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                Upcoming_Kontests_iOS_WidgetEntryView(entry: entry)
                    .containerBackground(Color.widgetBackground, for: .widget)
            } else {
                Upcoming_Kontests_iOS_WidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .supportedFamilies([.systemLarge, .systemExtraLarge])
        .configurationDisplayName("Kontest")
        .description("Get information about ongoing and upcoming kontests.")
    }
}

#Preview(as: .systemExtraLarge) {
    Upcoming_Kontest_iOS_Widget()
} timeline: {
    let kontestModel = KontestModel.from(dto: KontestDTO(name: "ProjectEuler+1,xd", url: "https://hackerrank.com/contests/projecteuler", start_time: "2023-08-15 18:29:00 UTC", end_time: "2023-08-18 17:43:00 UTC", duration: "1020.0", site: "HackerRank", in_24_hours: "No", status: "BEFORE"))

    SimpleEntry(
        date: .now,
        error: nil,
        allKontests: [kontestModel],
        filteredKontests: [kontestModel],
        ongoingKontests: [kontestModel],
        laterTodayKontests: [kontestModel],
        tomorrowKontests: [kontestModel, kontestModel],
        laterKontests: [kontestModel]
    )
}
