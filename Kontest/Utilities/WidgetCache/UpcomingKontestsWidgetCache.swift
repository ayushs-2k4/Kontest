//
//  UpcomingKontestsWidgetCache.swift
//  Kontest
//
//  Created by Ayush Singhal on 20/09/23.
//

import Foundation

//class UpcomingKontestsWidgetCache: WidgetCache {
//
//    
//    
//    typealias TimelineEntryType = SimpleEntry
//
//    var previousEntry: TimelineEntryType? = nil
//
//    func newEntryFromPrevious(withDate date: Date) -> TimelineEntryType? {
//        guard let previousEntry = previousEntry else { return nil }
//
//        return TimelineEntryType(
//            date: previousEntry.date,
//            error: previousEntry.error,
//            ongoingKontests: previousEntry.ongoingKontests,
//            laterTodayKontests: previousEntry.laterKontests,
//            tomorrowKontests: previousEntry.tomorrowKontests,
//            laterKontests: previousEntry.laterKontests
//        )
//    }
//
//    func storeNewEntry(_ entry: TimelineEntryType) {
//        previousEntry = entry
//    }
//}
//
//func persistWidgetCache(cache: UpcomingKontestsWidgetCache) {
//    let encoder = JSONEncoder()
//    do {
//        let data = try encoder.encode(cache)
//        UserDefaults.standard.set(data, forKey: "widgetCache")
//    } catch {
//        print(error)
//    }
//}
//
//func loadWidgetCache() -> UpcomingKontestsWidgetCache? {
//    let decoder = JSONDecoder()
//    guard let data = UserDefaults.standard.data(forKey: "widgetCache") else { return nil }
//
//    do {
//        let cache = try decoder.decode(UpcomingKontestsWidgetCache.self, from: data)
//        return cache
//    } catch {
//        print(error)
//        return nil
//    }
//}
