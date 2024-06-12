//
//  CalendarUtilityTests.swift
//  KontestTests
//
//  Created by Ayush Singhal on 18/09/23.
//

import Foundation
@testable import Kontest
import Testing

final class CalendarUtilityTests {
    let originalMinimumDurationOfAKontestInMinutes = UserDefaults(suiteName: Constants.userDefaultsGroupID)!.float(forKey: Constants.minimumDurationOfAKontestInMinutesKey)
    let originalMaximumDurationOfAKontestInMinutes = UserDefaults(suiteName: Constants.userDefaultsGroupID)!.float(forKey: Constants.maximumDurationOfAKontestInMinutesKey)

    init() {
        UserDefaults(suiteName: Constants.userDefaultsGroupID)?.set(0, forKey: Constants.minimumDurationOfAKontestInMinutesKey)
        UserDefaults(suiteName: Constants.userDefaultsGroupID)?.set(12 * 24 * 60, forKey: Constants.maximumDurationOfAKontestInMinutesKey) // 12 days
    }

    deinit {
        UserDefaults(suiteName: Constants.userDefaultsGroupID)?.set(originalMinimumDurationOfAKontestInMinutes, forKey: Constants.minimumDurationOfAKontestInMinutesKey)
        UserDefaults(suiteName: Constants.userDefaultsGroupID)?.set(originalMaximumDurationOfAKontestInMinutes, forKey: Constants.maximumDurationOfAKontestInMinutesKey)
    }

    @Test func test_getFormattedDate1_True() {
        let dateString = "2024-07-30T18:30:00.000Z"
        let formattedDate = CalendarUtility.getFormattedDate2(date: dateString)

        let correctDateComponents = DateComponents(timeZone: TimeZone(identifier: "UTC"), year: 2024, month: 7, day: 30, hour: 18, minute: 30, second: 0)
        let date = Calendar.current.date(from: correctDateComponents)!

        #expect(formattedDate == date)
    }

    @Test func test_getFormattedDate2_True() {
        let dateString = "2022-10-10 06:30:00 UTC"
        let formattedDate = CalendarUtility.getFormattedDate3(date: dateString)

        let correctDateComponents = DateComponents(timeZone: TimeZone(identifier: "UTC"), year: 2022, month: 10, day: 10, hour: 6, minute: 30, second: 0)
        let date = Calendar.current.date(from: correctDateComponents)!

        #expect(formattedDate == date)
    }

    @Test func test_getDate_Date1_True() {
        let dateString1 = "2022-10-10T06:30:00.000Z"
        let formattedDate1 = CalendarUtility.getDate(date: dateString1)

        let correctDateComponents1 = DateComponents(timeZone: TimeZone(identifier: "UTC"), year: 2022, month: 10, day: 10, hour: 6, minute: 30, second: 0)
        let date1 = Calendar.current.date(from: correctDateComponents1)!
        #expect(formattedDate1 == date1)
    }

    @Test func test_getDate_Date2_True() {
        let dateString2 = "2024-07-30 18:30:00 UTC"
        let formattedDate2 = CalendarUtility.getDate(date: dateString2)

        let correctDateComponents2 = DateComponents(timeZone: TimeZone(identifier: "UTC"), year: 2024, month: 7, day: 30, hour: 18, minute: 30, second: 0)
        let date2 = Calendar.current.date(from: correctDateComponents2)!
        #expect(formattedDate2 == date2)
    }

    @Test func test_isKontestOfPast_PastDate_True() {
        let pastDate = Date().addingTimeInterval(-100)

        #expect(CalendarUtility.isKontestOfPast(kontestEndDate: pastDate))
    }

    @Test func test_isKontestOfPast_FutureDate_True() {
        let futureDate = Date().addingTimeInterval(100)

        #expect(CalendarUtility.isKontestOfPast(kontestEndDate: futureDate) == false)
    }

    @Test func test_isKontestOfFuture_PastDate_False() {
        let pastDate = Date().addingTimeInterval(-100)

        #expect(CalendarUtility.isKontestOfFuture(kontestStartDate: pastDate) == false)
    }

    @Test func test_isKontestOfFuture_FutureDate_True() {
        let futureDate = Date().addingTimeInterval(100)

        #expect(CalendarUtility.isKontestOfFuture(kontestStartDate: futureDate))
    }

    // Test when currentDate is before kontestStartDate
    @Test func test_isKontestRunning_FutureDate_FutureDate_False() {
        let kontestStartDate = Date(timeIntervalSinceNow: 3600) // 1 hour from now
        let kontestEndDate = Date(timeIntervalSinceNow: 7200) // 2 hours from now

        #expect(CalendarUtility.isKontestRunning(kontestStartDate: kontestStartDate, kontestEndDate: kontestEndDate) == false)
    }

    // Test when currentDate is within the kontestStartDate and kontestEndDate
    @Test func test_isKontestRunning_PastDate_FutureDate_False() {
        let kontestStartDate = Date(timeIntervalSinceNow: -3600) // 1 hour ago
        let kontestEndDate = Date(timeIntervalSinceNow: 3600) // 1 hour from now

        #expect(CalendarUtility.isKontestRunning(kontestStartDate: kontestStartDate, kontestEndDate: kontestEndDate))
    }

    // Test when currentDate is after kontestEndDate
    @Test func test_isKontestRunning_PastDate_PastDate_False() {
        let kontestStartDate = Date(timeIntervalSinceNow: -7200) // 2 hours ago
        let kontestEndDate = Date(timeIntervalSinceNow: -3600) // 1 hour ago

        #expect(CalendarUtility.isKontestRunning(kontestStartDate: kontestStartDate, kontestEndDate: kontestEndDate) == false)
    }

    @Test func test_isKontestLaterToday_PastDate_False() {
        let kontestStartDate = Date(timeIntervalSinceNow: -100)

        #expect(CalendarUtility.isKontestLaterToday(kontestStartDate: kontestStartDate) == false)
    }

    @Test func test_isKontestLaterToday_LaterTodayDate_True() {
        let kontestStartDate = Date(timeIntervalSinceNow: 100)

        #expect(CalendarUtility.isKontestLaterToday(kontestStartDate: kontestStartDate))
    }

    @Test func test_isKontestLaterToday_Tomorrow_False() {
        let today = Date()
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: today))!
        let tomorrow2 = calendar.date(bySetting: .hour, value: 3, of: tomorrow)!

        #expect(CalendarUtility.isKontestLaterToday(kontestStartDate: tomorrow2) == false)
    }

    @Test func test_isKontestLaterToday_LaterDate_False() {
        let kontestStartDate = Date().addingTimeInterval(86400 * 1.5)

        #expect(CalendarUtility.isKontestLaterToday(kontestStartDate: kontestStartDate) == false)
    }

    @Test func test_isKontestTomorrow_PastDate_False() {
        let kontestStartDate = Date(timeIntervalSinceNow: -86400 * 1.5)

        #expect(CalendarUtility.isKontestTomorrow(kontestStartDate: kontestStartDate) == false)
    }

    @Test func test_isKontestTomorrow_PresentDate_False() {
        let kontestStartDate = Date()

        #expect(CalendarUtility.isKontestTomorrow(kontestStartDate: kontestStartDate) == false)
    }

    @Test func test_isKontestTomorrow_LaterTodayDate_False() {
        let kontestStartDate = Date(timeIntervalSinceNow: 200)

        #expect(CalendarUtility.isKontestTomorrow(kontestStartDate: kontestStartDate) == false)
    }

    @Test func test_isKontestTomorrow_TomorrowDate_True() {
        let today = Date()
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: today))!
        let tomorrow2 = calendar.date(bySetting: .hour, value: 3, of: tomorrow)!

        #expect(CalendarUtility.isKontestTomorrow(kontestStartDate: tomorrow2))
    }

    @Test func test_isKontestTomorrow_Later_False() {
        let kontestStartDate = Date().addingTimeInterval(86400 * 3)

        #expect(CalendarUtility.isKontestTomorrow(kontestStartDate: kontestStartDate) == false)
    }

    @Test func test_isKontestLater_PastDate_False() {
        let kontestStartDate = Date(timeIntervalSinceNow: -100)

        #expect(CalendarUtility.isKontestLater(kontestStartDate: kontestStartDate) == false)
    }

    @Test func test_isKontestLater_PresentDate_False() {
        let kontestStartDate = Date()

        #expect(CalendarUtility.isKontestLater(kontestStartDate: kontestStartDate) == false)
    }

    @Test func test_isKontestLater_LaterTodayDate_False() {
        let kontestStartDate = Date(timeIntervalSinceNow: 200)

        #expect(CalendarUtility.isKontestLater(kontestStartDate: kontestStartDate) == false)
    }

    @Test func test_isKontestLater_TomorrowDate_False() {
        let today = Date()
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: today))!
        let tomorrow2 = calendar.date(bySetting: .hour, value: 3, of: tomorrow)!

        #expect(CalendarUtility.isKontestLater(kontestStartDate: tomorrow2) == false)
    }

    @Test func test_isKontestLater_LaterDate_True() {
        let kontestStartDate = Date().addingTimeInterval(86400 * 3)

        #expect(CalendarUtility.isKontestLater(kontestStartDate: kontestStartDate))
    }

    @Test func test_getFormattedDuration_1Hour_1h() {
        #if os(iOS)
            #expect(CalendarUtility.getFormattedDuration(fromSeconds: "3600") == "1h")
        #else
            #expect(CalendarUtility.getFormattedDuration(fromSeconds: "3600") == "1 hour")
        #endif
    }

    @Test func test_getFormattedDuration_2Hours_2h() {
        #if os(iOS)
            #expect(CalendarUtility.getFormattedDuration(fromSeconds: "7200") == "2h")
        #else
            #expect(CalendarUtility.getFormattedDuration(fromSeconds: "7200") == "2 hours")
        #endif
    }

    @Test func test_getFormattedDuration_1Hour30Minutes_1h30m() {
        #if os(iOS)
            #expect(CalendarUtility.getFormattedDuration(fromSeconds: "5400") == "1h 30m")
        #else
            #expect(CalendarUtility.getFormattedDuration(fromSeconds: "5400") == "1 hour, 30 minutes")
        #endif
    }

    @Test func test_getFormattedDuration_1Day12Hours_1d12h() {
        #if os(iOS)
            #expect(CalendarUtility.getFormattedDuration(fromSeconds: "129600", minimumDuration: 0, maximumDuration: 10 * 24 * 60) == "1d 12h")
        #else
            #expect(CalendarUtility.getFormattedDuration(fromSeconds: "129600", minimumDuration: 0, maximumDuration: 10 * 24 * 60) == "1 day, 12 hours")
        #endif
    }

    @Test func test_getFormattedDuratiosn_1Day4Hours48Minutes_1d4h48m() {
        #if os(iOS)
            #expect(CalendarUtility.getFormattedDuration(fromSeconds: "103680", minimumDuration: 0, maximumDuration: 10 * 24 * 60) == "1d 4h 48m")
        #else
            #expect(CalendarUtility.getFormattedDuration(fromSeconds: "103680", minimumDuration: 0, maximumDuration: 10 * 24 * 60) == "1 day, 4 hours, 48 minutes")
        #endif
    }

    @Test func test_getFormattedDuratiosn_1Day4Hours48Minutes2Seconds_1d4h48m() {
        #if os(iOS)
            #expect(CalendarUtility.getFormattedDuration(fromSeconds: "103682", minimumDuration: 0, maximumDuration: 10 * 24 * 60) == "1d 4h 48m")
        #else
            #expect(CalendarUtility.getFormattedDuration(fromSeconds: "103682", minimumDuration: 0, maximumDuration: 10 * 24 * 60) == "1 day, 4 hours, 48 minutes")
        #endif
    }

    @Test func test_getFormattedDuratiosn_16Days_1d4h48m() {
        #expect(CalendarUtility.getFormattedDuration(fromSeconds: "1382400") == nil)
    }

    @Test func test_getFormattedDuration_Invalid_InvalidDuration() {
        #expect(CalendarUtility.getFormattedDuration(fromSeconds: "1,29,600") == "Invalid Duration")
    }
}
