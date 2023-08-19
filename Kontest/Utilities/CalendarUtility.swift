//
//  CalendarUtility.swift
//  Kontest
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

    // DateFormatter for the first format: "2024-07-30T18:30:00.000Z"
    static func getFormattedDate1(date: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        let currentDate = formatter.date(from: date)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"

        return currentDate
    }

    // DateFormatter for the second format: "2022-10-10 06:30:00 UTC"
    static func getFormattedDate2(date: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz" // 2023-08-30 14:30:00 UTC
        formatter.locale = Locale(identifier: "en_US_POSIX")

        let currentDate = formatter.date(from: date)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"

        return currentDate
    }

    static func getDate(date: String) -> Date? {
        if let ansDate = getFormattedDate1(date: date) {
            return ansDate
        } else if let ansDate = getFormattedDate2(date: date) {
            return ansDate
        } else {
            return nil
        }
    }

    static func isKontestOfPast(kontestEndDate: Date) -> Bool {
        let currentDate = Date()
        let ans = kontestEndDate <= currentDate
        return ans
    }

    static func isKontestOfFuture(kontestStartDate: Date) -> Bool {
        return Date() <= kontestStartDate
    }

    static func isKontestRunning(kontestStartDate: Date, kontestEndDate: Date) -> Bool {
        let currentDate = Date()
        return currentDate >= kontestStartDate && currentDate <= kontestEndDate
    }

    static func getFormattedDuration(fromSeconds seconds: String) -> String? {
        guard let totalSecondsInDouble = Double(seconds) else {
            return "Invalid Duration"
        }

        let totalSeconds = Int(totalSecondsInDouble)

        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60

        let formatter = DateComponentsFormatter()
        #if os(iOS)
            formatter.unitsStyle = .abbreviated
        #else
            formatter.unitsStyle = .full
        #endif

        formatter.allowedUnits = [.day, .hour, .minute, .second]

        let dateComponents = DateComponents(hour: hours, minute: minutes)

        let ans = dateComponents.hour ?? 1 <= 360 ? formatter.string(from: dateComponents) : nil
        return ans
    }

    static func getTimeBefore(originalDate: Date, minutes: Int, hours: Int, days: Int) -> Date {
        var components = DateComponents()
        components.minute = -minutes
        components.hour = -hours
        components.day = -days

        if let newDate = Calendar.current.date(byAdding: components, to: originalDate) {
            return newDate
        }

        return originalDate
    }

    static func getNumericKontestDate(date: Date) -> String {
        #if os(iOS)
            "\(date.formatted(date: .numeric, time: .omitted))"
        #else
            "\(date.formatted(date: .abbreviated, time: .omitted))"
        #endif
    }

    static func getKontestDate(date: Date) -> String {
        #if os(iOS)
            "\(date.formatted(date: .abbreviated, time: .omitted))"
        #else
            "\(date.formatted(date: .abbreviated, time: .omitted))"
        #endif
    }

    static func convertUTCToLocal(utcDate: Date) -> Date? {
        let localTimeZone = TimeZone.current
        let secondsFromGMT = localTimeZone.secondsFromGMT(for: utcDate)
        return Date(timeInterval: TimeInterval(secondsFromGMT), since: utcDate)
    }

    static func getTomorrow() -> Date {
        let today = Date()
        let tomorrow = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: today)!
        return tomorrow
    }

    static func getDayAfterTomorrow() -> Date {
        let today = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        let dayAfterTomorrow = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: tomorrow)!
        return dayAfterTomorrow
    }

    static func getTimeDifferenceString(startDate: Date, endDate: Date) -> String {
        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: startDate, to: endDate)

        var formattedTime = ""

        if let days = components.day, days > 0 {
            formattedTime.append("\(days)D")
        } else {
            if let minutes = components.minute, minutes > 0 {
                if let hours = components.hour, hours > 0 {
                    formattedTime.append("\(hours)H \(minutes)M")
                } else {
                    formattedTime.append("\(minutes)M")
                }
            } else {
                if let hours = components.hour, hours > 0 {
                    formattedTime.append("\(hours)H")
                }
            }
        }

        return formattedTime.isEmpty ? "0H" : formattedTime
    }

    static func getWeekdayNameFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: date).uppercased()
    }

    static func getTimeFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
}
