//
//  AllKontestsViewModelTests.swift
//  KontestTests
//
//  Created by Ayush Singhal on 18/09/23.
//

@testable import Kontest
import XCTest

class AllKontestsViewModelTests: XCTestCase {
    var viewModel: AllKontestsViewModel!

    override func setUp() async throws {
        viewModel = AllKontestsViewModel(
            notificationsViewModel: MockNotificationsViewModel(),
            filterWebsitesViewModel: MockFilterWebsitesViewModel(),
            repository: KontestsTestFakeRepository()
        )
    }

    override func tearDown() {
        viewModel = nil
    }

    func testInitialization() {
        let expectation = XCTNSPredicateExpectation(predicate: NSPredicate(block: { [weak self] _, _ in
            self?.viewModel.allKontests.count == 2 && self?.viewModel.toShowKontests.count == 1
        }), object: nil)
        wait(for: [expectation], timeout: 2)
    }
}

class KontestsTestFakeRepository: KontestFetcher {
    func getAllKontests() async throws -> [Kontest.KontestDTO] {
        var allKontests: [KontestDTO]

        let startDate = Date().addingTimeInterval(86400 * 2)
        let endDate = Date().addingTimeInterval(86400 * 5)

        let startDateString = CalendarUtility.formatDateToString(startDate)
        let endDateString = CalendarUtility.formatDateToString(endDate)

        print("startDateString: \(startDateString)")

        allKontests = [
            KontestDTO(name: "ProjectEuler+1", url: "https://hackerrank.com/contests/projecteuler", start_time: startDateString, end_time: endDateString, duration: "1020.0", site: "HackerRank", in_24_hours: "No", status: "BEFORE"),

            KontestDTO(name: "1v1 Games by CodeChef", url: "https://www.codechef.com/GAMES", start_time: "2022-10-10 06:30:00 UTC", end_time: "2032-10-10 06:30:00 UTC", duration: "315619200.0", site: "CodeChef", in_24_hours: "No", status: "CODING"), // Expired

            KontestDTO(name: "Weekly Contest 358", url: "https://leetcode.com/contest/weekly-contest-358", start_time: startDateString, end_time: endDateString, duration: "5400", site: "LeetCode", in_24_hours: "Yes", status: "BEFORE")
        ]

        return allKontests
    }
}
