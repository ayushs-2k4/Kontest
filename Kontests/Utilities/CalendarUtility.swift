//
//  CalendarUtility.swift
//  Kontests
//
//  Created by Ayush Singhal on 13/08/23.
//

import Foundation

class CalendarUtility {
    static func generateCalendarURL(startDate: Date?, endDate: Date?) -> String {
        let utcStartDate = startDate!.addingTimeInterval(-Double(TimeZone.current.secondsFromGMT(for: startDate!)))
        let utcEndDate = endDate!.addingTimeInterval(-Double(TimeZone.current.secondsFromGMT(for: endDate!)))

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")

        let utcStartString = dateFormatter.string(from: utcStartDate)
        let utcEndString = dateFormatter.string(from: utcEndDate)

        let calendarURL = "https://www.google.com/calendar/render?action=TEMPLATE&dates=\(utcStartString)%2F\(utcEndString)"

        return calendarURL
    }
}
