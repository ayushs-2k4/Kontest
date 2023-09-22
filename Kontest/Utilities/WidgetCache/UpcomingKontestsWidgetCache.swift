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

        let allEvents = try? await CalendarUtility.getAllEvents()
        previousWidgetCache.ongoingKontests.forEach { kontest in
            kontest.loadCalendarStatus(allEvents: allEvents ?? [])
            logger.info("Ran loadCalendarStatus offline for \(kontest.name) with \(kontest.isCalendarEventAdded)")
        }
        
        previousWidgetCache.laterTodayKontests.forEach { kontest in
            kontest.loadCalendarStatus(allEvents: allEvents ?? [])
            logger.info("Ran loadCalendarStatus offline for \(kontest.name) with \(kontest.isCalendarEventAdded)")
        }
        
        previousWidgetCache.tomorrowKontests.forEach { kontest in
            kontest.loadCalendarStatus(allEvents: allEvents ?? [])
            logger.info("Ran loadCalendarStatus offline for \(kontest.name) with \(kontest.isCalendarEventAdded)")
        }
        
        previousWidgetCache.laterKontests.forEach { kontest in
            kontest.loadCalendarStatus(allEvents: allEvents ?? [])
            logger.info("Ran loadCalendarStatus offline for \(kontest.name) with \(kontest.isCalendarEventAdded)")
        }

        return previousWidgetCache
    }

    func storeNewEntry(_ entry: TimelineEntryType) {
        previousEntry = entry
        if let previousEntry {
            persistWidgetCache(cache: previousEntry)
        }
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
            print(error)
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
            print(error)
            return nil
        }
    }
}
