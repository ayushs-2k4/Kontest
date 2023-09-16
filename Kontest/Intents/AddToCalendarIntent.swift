//
//  AddToCalendarIntent.swift
//  Kontest
//
//  Created by Ayush Singhal on 16/09/23.
//

import AppIntents
import Foundation
import OSLog

struct AddToCalendarIntent: AppIntent {
    private let logger = Logger(subsystem: "com.ayushsinghal.Kontest", category: "AddToCalendarIntent")
    init() {}

    static var title: LocalizedStringResource = "Add to Calendar"

    @Parameter(title: "Kontest")
    var kontest: KontestWidgetModel

    init(kontest: KontestWidgetModel) {
        self.kontest = kontest
    }

    func perform() async throws -> some IntentResult {
//        print("A")
//        logger.info("A")

        UserDefaults.standard.setValue("aysuhsmdws", forKey: "leetcodeUsername")

//        Task {
//            if try await CalendarUtility.addEvent(startDate: Date().addingTimeInterval(86400), endDate: Date().addingTimeInterval(86400 * 2), title: "Title", notes: "Notes", url: URL(string: "https://www.youtube.com/watch?v=_a5Zcqgq_GQ")) {}
//
//            print("B")
//            logger.info("B")
//        }

        return .result()
    }
}
