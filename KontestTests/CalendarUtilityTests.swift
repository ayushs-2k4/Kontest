//
//  CalendarUtilityTests.swift
//  KontestTests
//
//  Created by Ayush Singhal on 18/09/23.
//

@testable import Kontest
import XCTest

class CalendarUtilityTests: XCTestCase {
    func test_getFormattedDate1_True() {
        let dateString = "2024-07-30T18:30:00.000Z"
        let formattedDate = CalendarUtility.getFormattedDate1(date: dateString)

        let correctDateComponents = DateComponents(timeZone: TimeZone(identifier: "UTC"), year: 2024, month: 7, day: 30, hour: 18, minute: 30, second: 0)
        let date = Calendar.current.date(from: correctDateComponents)!

        XCTAssertEqual(formattedDate, date)
    }

    func test_getFormattedDate2_True() {
        let dateString = "2022-10-10 06:30:00 UTC"
        let formattedDate = CalendarUtility.getFormattedDate2(date: dateString)

        let correctDateComponents = DateComponents(timeZone: TimeZone(identifier: "UTC"), year: 2022, month: 10, day: 10, hour: 6, minute: 30, second: 0)
        let date = Calendar.current.date(from: correctDateComponents)!

        XCTAssertEqual(formattedDate, date)
    }

    func test_getDate_Date1_True() {
        let dateString1 = "2022-10-10T06:30:00.000Z"
        let formattedDate1 = CalendarUtility.getDate(date: dateString1)

        let correctDateComponents1 = DateComponents(timeZone: TimeZone(identifier: "UTC"), year: 2022, month: 10, day: 10, hour: 6, minute: 30, second: 0)
        let date1 = Calendar.current.date(from: correctDateComponents1)!
        XCTAssertEqual(formattedDate1, date1)
    }

    func test_getDate_Date2_True() {
        let dateString2 = "2024-07-30 18:30:00 UTC"
        let formattedDate2 = CalendarUtility.getDate(date: dateString2)

        let correctDateComponents2 = DateComponents(timeZone: TimeZone(identifier: "UTC"), year: 2024, month: 7, day: 30, hour: 18, minute: 30, second: 0)
        let date2 = Calendar.current.date(from: correctDateComponents2)!
        XCTAssertEqual(formattedDate2, date2)
    }

    func test_isKontestOfPast_PastDate_True() {
        let pastDate = Date().addingTimeInterval(-100)

        XCTAssertTrue(CalendarUtility.isKontestOfPast(kontestEndDate: pastDate))
    }

    func test_isKontestOfPast_FutureDate_True() {
        let futureDate = Date().addingTimeInterval(100)

        XCTAssertFalse(CalendarUtility.isKontestOfPast(kontestEndDate: futureDate))
    }

    func test_isKontestOfFuture_PastDate_False() {
        let pastDate = Date().addingTimeInterval(-100)

        XCTAssertFalse(CalendarUtility.isKontestOfFuture(kontestStartDate: pastDate))
    }

    func test_isKontestOfFuture_FutureDate_True() {
        let futureDate = Date().addingTimeInterval(100)

        XCTAssertTrue(CalendarUtility.isKontestOfFuture(kontestStartDate: futureDate))
    }

    // Test when currentDate is before kontestStartDate
    func test_isKontestRunning_FutureDate_FutureDate_False() {
        let kontestStartDate = Date(timeIntervalSinceNow: 3600) // 1 hour from now
        let kontestEndDate = Date(timeIntervalSinceNow: 7200) // 2 hours from now

        XCTAssertFalse(CalendarUtility.isKontestRunning(kontestStartDate: kontestStartDate, kontestEndDate: kontestEndDate))
    }

    // Test when currentDate is within the kontestStartDate and kontestEndDate
    func test_isKontestRunning_PastDate_FutureDate_False() {
        let kontestStartDate = Date(timeIntervalSinceNow: -3600) // 1 hour ago
        let kontestEndDate = Date(timeIntervalSinceNow: 3600) // 1 hour from now

        XCTAssertTrue(CalendarUtility.isKontestRunning(kontestStartDate: kontestStartDate, kontestEndDate: kontestEndDate))
    }

    // Test when currentDate is after kontestEndDate
    func test_isKontestRunning_PastDate_PastDate_False() {
        let kontestStartDate = Date(timeIntervalSinceNow: -7200) // 2 hours ago
        let kontestEndDate = Date(timeIntervalSinceNow: -3600) // 1 hour ago

        XCTAssertFalse(CalendarUtility.isKontestRunning(kontestStartDate: kontestStartDate, kontestEndDate: kontestEndDate))
    }
}
