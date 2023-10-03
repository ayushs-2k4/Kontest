//
//  UpcomingKontestsWidgetCache.swift
//  Kontest
//
//  Created by Ayush Singhal on 20/09/23.
//

import Foundation
import OSLog

class UpcomingKontestsWidgetCache: WidgetCache {
    private let logger = Logger(subsystem: "com.ayushsinghal.Kontest", category: "UpcomingKontestsWidgetCache")

    enum CodingKeys: CodingKey {
        case previousEntry
    }

    init() {}

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        previousEntry = try container.decode(TimelineEntryType.self, forKey: .previousEntry)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(previousEntry, forKey: .previousEntry)
    }

    typealias TimelineEntryType = SimpleEntry

    var previousEntry: TimelineEntryType? = nil

    func newEntryFromPrevious(withDate date: Date) async -> TimelineEntryType? {
        guard let previousWidgetCache = loadWidgetCache() else { return nil }

        let newlyFilteredKontests = getFilteredKontests(allKontests: previousWidgetCache.allKontests) // Filtered kontests where date might have changed like from tomorrow to today

        let allEvents = try? await CalendarUtility.getAllEvents()

        newlyFilteredKontests.ongoingKontests.forEach { kontest in
            kontest.loadCalendarStatus(allEvents: allEvents ?? [])
            logger.info("Ran loadCalendarStatus offline for \(kontest.name) with \(kontest.isCalendarEventAdded)")
        }

        newlyFilteredKontests.laterTodayKontests.forEach { kontest in
            kontest.loadCalendarStatus(allEvents: allEvents ?? [])
            logger.info("Ran loadCalendarStatus offline for \(kontest.name) with \(kontest.isCalendarEventAdded)")
        }

        newlyFilteredKontests.tomorrowKontests.forEach { kontest in
            kontest.loadCalendarStatus(allEvents: allEvents ?? [])
            logger.info("Ran loadCalendarStatus offline for \(kontest.name) with \(kontest.isCalendarEventAdded)")
        }

        newlyFilteredKontests.laterKontests.forEach { kontest in
            kontest.loadCalendarStatus(allEvents: allEvents ?? [])
            logger.info("Ran loadCalendarStatus offline for \(kontest.name) with \(kontest.isCalendarEventAdded)")
        }

        return TimelineEntryType(
            date: Date(),
            error: nil,
            allKontests: newlyFilteredKontests.allKontests,
            filteredKontests: newlyFilteredKontests.filteredKontests,
            ongoingKontests: newlyFilteredKontests.ongoingKontests,
            laterTodayKontests: newlyFilteredKontests.laterTodayKontests,
            tomorrowKontests: newlyFilteredKontests.tomorrowKontests,
            laterKontests: newlyFilteredKontests.laterKontests
        )
    }

    func storeNewEntry(_ entry: TimelineEntryType) {
        previousEntry = entry
        if let previousEntry {
            persistWidgetCache(cache: previousEntry)
        }
    }

    func getFilteredKontests(allKontests: [KontestModel]) -> (
        allKontests: [KontestModel],
        filteredKontests: [KontestModel],
        ongoingKontests: [KontestModel],
        laterTodayKontests: [KontestModel],
        tomorrowKontests: [KontestModel],
        laterKontests: [KontestModel]
    ) // Filters given kontests where date might have changed like from tomorrow to today
    {
        let newAllKontests = allKontests.filter { kontest in
            let kontestEndDate = CalendarUtility.getDate(date: kontest.end_time)
            let isKontestEnded = CalendarUtility.isKontestOfPast(kontestEndDate: kontestEndDate ?? Date())

            return !isKontestEnded
        }

        let allowedWebsites = FilterWebsitesViewModel().getAllowedWebsites()
        let filteredKontests = newAllKontests.filter { kontest in
            allowedWebsites.contains(kontest.site)
        }

        let today = Date()

        let ongoingKontests = filteredKontests.filter { CalendarUtility.isKontestRunning(kontestStartDate: CalendarUtility.getDate(date: $0.start_time) ?? today, kontestEndDate: CalendarUtility.getDate(date: $0.end_time) ?? today) }

        let laterTodayKontests = filteredKontests.filter { CalendarUtility.isKontestLaterToday(kontestStartDate: CalendarUtility.getDate(date: $0.start_time) ?? Date()) }

        let tomorrowKontests = filteredKontests.filter { CalendarUtility.isKontestTomorrow(kontestStartDate: CalendarUtility.getDate(date: $0.start_time) ?? Date()) }

        let laterKontests = filteredKontests.filter { CalendarUtility.isKontestLater(kontestStartDate: CalendarUtility.getDate(date: $0.start_time) ?? Date()) }

        var ans: ([KontestModel], [KontestModel], [KontestModel], [KontestModel], [KontestModel], [KontestModel])
        ans = (allKontests, filteredKontests, ongoingKontests, laterTodayKontests, tomorrowKontests, laterKontests)
        return ans
    }
}

extension UpcomingKontestsWidgetCache {
    func persistWidgetCache(cache: TimelineEntryType) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(cache)
            UserDefaults.standard.set(data, forKey: "widgetCache")
            let str = String(decoding: data, as: UTF8.self)
            logger.info("saved data: \(str)")
            logger.info("Saved widget cache")
        } catch {
            logger.error("\(error.localizedDescription, privacy: .public)")
        }
    }

    func loadWidgetCache() -> TimelineEntryType? {
        let decoder = JSONDecoder()
        guard let data = UserDefaults.standard.data(forKey: "widgetCache") else { return nil }
        let str = String(decoding: data, as: UTF8.self)
        logger.info("loaded data: \(str)")

        do {
            let cache = try decoder.decode(TimelineEntryType.self, from: data)
            logger.info("Loaded widget cache")
            return cache
        } catch {
            logger.error("\(error.localizedDescription, privacy: .public)")
            return nil
        }
    }
}
