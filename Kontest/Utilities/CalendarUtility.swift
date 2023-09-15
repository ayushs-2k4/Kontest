//
//  CalendarUtility.swift
//  Kontest
//
//  Created by Ayush Singhal on 13/08/23.
//

import EventKit
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

    static func isKontestLaterToday(kontestStartDate: Date) -> Bool {
        let currentDate = Date()
        let tomorrow = CalendarUtility.getTomorrow()
        return kontestStartDate > currentDate && kontestStartDate < tomorrow
    }

    static func isKontestTomorrow(kontestStartDate: Date) -> Bool {
        let tomorrow = CalendarUtility.getTomorrow()
        let dayAfterTomorrow = CalendarUtility.getDayAfterTomorrow()

        return kontestStartDate > tomorrow && kontestStartDate < dayAfterTomorrow
    }

    static func isKontestLater(kontestStartDate: Date) -> Bool {
        let dayAfterTomorrow = CalendarUtility.getDayAfterTomorrow()

        return kontestStartDate > dayAfterTomorrow
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
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: today))!
        return tomorrow
    }

    static func getDayAfterTomorrow() -> Date {
        let today = Date()
        let calendar = Calendar.current
        let dayAfterTomorrow = calendar.date(byAdding: .day, value: 2, to: calendar.startOfDay(for: today))!
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

    static func isRemainingTimeGreaterThanGivenTime(date: Date?, minutes: Int = 0, hours: Int = 0, days: Int = 0) -> Bool {
        let calendar = Calendar.current
        let currentDate = Date()

        guard let date, let targetDate = calendar.date(byAdding: .minute, value: minutes, to: currentDate),
              let targetDateWithHours = calendar.date(byAdding: .hour, value: hours, to: targetDate),
              let targetDateWithDays = calendar.date(byAdding: .day, value: days, to: targetDateWithHours)
        else {
            return false
        }

        return targetDateWithDays < date
    }

    static func formattedTimeFrom(seconds: Int) -> String {
        let days = seconds / 86400 // 86400 seconds in a day
        let hours = (seconds % 86400) / 3600
        let minutes = (seconds % 3600) / 60
        let remainingSeconds = seconds % 60

        return if days > 0 {
            if days == 1 {
                String(format: "%d day and %02d:%02d:%02d", days, hours, minutes, remainingSeconds)
            } else {
                String(format: "%d days and %02d:%02d:%02d", days, hours, minutes, remainingSeconds)
            }
        } else if hours > 0 {
            String(format: "%02d:%02d:%02d", hours, minutes, remainingSeconds)
        } else {
            String(format: "%02d:%02d", minutes, remainingSeconds)
        }
    }

    static func shortenedFormattedTimeFrom(seconds: Int) -> String {
        let days = seconds / 86400 // 86400 seconds in a day
        let hours = (seconds % 86400) / 3600
        let minutes = (seconds % 3600) / 60
        let remainingSeconds = seconds % 60

        return if days > 0 {
            String(format: "%dd, %02d:%02d:%02d", days, hours, minutes, remainingSeconds)
        } else if hours > 0 {
            String(format: "%02d:%02d:%02d", hours, minutes, remainingSeconds)
        } else {
            String(format: "%02d:%02d", minutes, remainingSeconds)
        }
    }

    static func getNextDateToRefresh(ongoingKontests: [KontestModel], laterTodayKontests: [KontestModel], tomorrowKontests: [KontestModel], laterKontests: [KontestModel]) -> Date {
        let maxNextDateToRefresh = Date.now.advanced(by: 0.5 * 60 * 60)
        var nextDateToRefresh = maxNextDateToRefresh

        if !ongoingKontests.isEmpty {
            let endTime = CalendarUtility.getDate(date: ongoingKontests.first!.end_time) ?? maxNextDateToRefresh

            if endTime > .now {
                nextDateToRefresh = min(nextDateToRefresh, endTime)
            }
        }

        if !laterTodayKontests.isEmpty {
            let startTime = CalendarUtility.getDate(date: laterTodayKontests.first!.start_time) ?? maxNextDateToRefresh

            if startTime > .now {
                nextDateToRefresh = min(nextDateToRefresh, startTime)
            }
        }

        if !tomorrowKontests.isEmpty {
            let startTime = CalendarUtility.getDate(date: tomorrowKontests.first!.start_time) ?? maxNextDateToRefresh

            if startTime > .now {
                nextDateToRefresh = min(nextDateToRefresh, startTime)
            }
        }

        if !laterKontests.isEmpty {
            let startTime = CalendarUtility.getDate(date: laterKontests.first!.start_time) ?? maxNextDateToRefresh

            if startTime > .now {
                nextDateToRefresh = min(nextDateToRefresh, startTime)
            }
        }

        if let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) {
            if let tomorrowAtMidnight = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: tomorrow) {
                nextDateToRefresh = min(nextDateToRefresh, tomorrowAtMidnight)
            }
        }

        return nextDateToRefresh
    }

    private static func requestFullAccessToReminders() async throws -> Bool {
        let store = EKEventStore()

//        var isPermissionGranted = false

        do {
            try await store.requestFullAccessToEvents()
        } catch {
            throw error
        }

        let ans = EKEventStore.authorizationStatus(for: EKEntityType.event) == .fullAccess
        return ans
//        return isPermissionGranted
    }

    static func addEvent(startDate: Date, endDate: Date, title: String, notes: String, url: URL?) {
        let store = EKEventStore()

        print("Yes")

        store.requestWriteOnlyAccessToEvents { isGranted, error in
            if let error {
                print("Error: \(error)")
            }

            print("isGranted: \(isGranted)")
        }

        let event = EKEvent(eventStore: store)
        event.calendar = store.defaultCalendarForNewEvents
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.notes = notes
        event.url = url

        do {
            try store.save(event, span: .thisEvent)
            print("Event saved")
            print(event)
        } catch {
            print("Error in saving event: \(error)")
        }
    }

    private static func getAllEvents() async -> [EKEvent]? {
        let store = EKEventStore()

        print("FullAccessYes")

        do {
            let isGranted = try await requestFullAccessToReminders()

            if !isGranted {
                print("Full Access To Reminders not Granted")
                return nil
            }
        } catch {
            print("Error in requesting Full Access To Reminders")
            return nil
        }

        guard let interval = Calendar.current.dateInterval(of: .hour, for: Date()) else { return nil }

        let predicate = store.predicateForEvents(withStart: interval.start, end: interval.end, calendars: nil)

        let events = store.events(matching: predicate)

        print("FullAccessinterval: \(interval)")
        print("FullAccess Events: \(events)")

        return events
    }

    static func removeEvent(startDate: Date, endDate: Date, title: String, notes: String, url: URL?) async {
        let allEvents = await getAllEvents()

        let events = allEvents?.filter { event in
            event.startDate == startDate && event.endDate == endDate && event.title == title && event.notes == notes
        }

        if let events, events.count == 1 {
            let store = EKEventStore()

            try? store.remove(events[0], span: .thisEvent)
        }
    }
}
