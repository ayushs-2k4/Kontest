//
//  AddToCalendarIntent.swift
//  Kontest
//
//  Created by Ayush Singhal on 16/09/23.
//

import AppIntents
import Foundation
import OSLog
import WidgetKit

struct AddToCalendarIntent: AppIntent {
    init() {}

    private let logger = Logger(subsystem: "com.ayushsinghal.Kontest", category: "AddToCalendarIntent")

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

    init(title: String, notes: String, startDate: Date, endDate: Date, url: URL?) {
        self.title = title
        self.notes = notes
        self.startDate = startDate
        self.endDate = endDate
        self.url = url
    }


    func perform() async throws -> some IntentResult {
        print("A")
        logger.info("A")
        UserDefaults(suiteName: "group.com.ayushsinghal.kontest")!.set("Value from Intent 2", forKey: "myCustomKeysAyush")
        UserDefaults(suiteName: "group.com.ayushsinghal.kontest")!.synchronize()
        WidgetCenter.shared.reloadAllTimelines()

        Task {
            if try await CalendarUtility.addEvent(startDate: startDate, endDate: endDate, title: title, notes: notes, url: url) {
                print("Succesfully setted")
            }
//
            print("B")
            logger.info("B")
        }

        return .result()
    }
}
