//
//  AddToCalendarIntent.swift
//  Kontest
//
//  Created by Ayush Singhal on 16/09/23.
//

import AppIntents
import Foundation
import WidgetKit

struct AddToCalendarIntent: AppIntent, Hashable {
    static func == (lhs: AddToCalendarIntent, rhs: AddToCalendarIntent) -> Bool {
        lhs.title == rhs.title &&
            lhs.notes == rhs.notes &&
            lhs.startDate == rhs.startDate &&
            lhs.endDate == rhs.endDate &&
            lhs.url == rhs.url &&
            lhs.toRemove == rhs.toRemove
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(notes)
        hasher.combine(startDate)
        hasher.combine(endDate)
        hasher.combine(url)
        hasher.combine(toRemove)
    }

    init() {}

    static var title: LocalizedStringResource = "Add to Calendar"

    static var isDiscoverable: Bool = false

    @Parameter(title: "title")
    var title: String

    @Parameter(title: "notes")
    var notes: String

    @Parameter(title: "startDate")
    var startDate: Date

    @Parameter(title: "endDate")
    var endDate: Date

    @Parameter(title: "url")
    var url: URL?

    @Parameter(title: "toRemove")
    var toRemove: Bool

    init(title: String, notes: String, startDate: Date, endDate: Date, url: URL?, toRemove: Bool) {
        self.title = title
        self.notes = notes
        self.startDate = startDate
        self.endDate = endDate
        self.url = url
        self.toRemove = toRemove
    }

    func perform() async throws -> some IntentResult {
        if toRemove {
            try await CalendarUtility.removeEvent(startDate: startDate, endDate: endDate, title: title, notes: notes, url: url)
        } else {
            if try await CalendarUtility.addEvent(startDate: startDate, endDate: endDate, title: title, notes: notes, url: url, alarmAbsoluteDate: startDate.addingTimeInterval(-15 * 60)) {
                print("Event Successfully added.")
            }
        }

        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}
