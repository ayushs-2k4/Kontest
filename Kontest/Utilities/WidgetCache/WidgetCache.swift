//
//  WidgetCache.swift
//  Kontest
//
//  Created by Ayush Singhal on 20/09/23.
//

import Intents
import WidgetKit

protocol WidgetCache: Codable, Sendable {
    associatedtype TimelineEntryType: TimelineEntry

    var previousEntry: TimelineEntryType? { get set }
    func newEntryFromPrevious(withDate date: Date) async -> TimelineEntryType?
    func storeNewEntry(_ entry: TimelineEntryType) -> Void
}
