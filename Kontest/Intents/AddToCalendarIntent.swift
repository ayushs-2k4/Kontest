//
//  AddToCalendarIntent.swift
//  Kontest
//
//  Created by Ayush Singhal on 16/09/23.
//

import AppIntents
import Foundation
import WidgetKit

struct AddToCalendarIntent: AppIntent {
    init() {}

    static var title: LocalizedStringResource = "Add to Calendar"

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
            if try await CalendarUtility.addEvent(startDate: startDate, endDate: endDate, title: title, notes: notes, url: url) {
                print("Event Successfully added.")
            }
        }

        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}
