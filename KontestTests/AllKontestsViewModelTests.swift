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
            filterWebsitesViewModel: MockFilterWebsitesViewModel(allowedWebsites: ["LeetCode", "CodeForces", "HackerEarth"]),
            repository: KontestsTestFakeRepository()
        )
    }

    override func tearDown() {
        viewModel = nil
    }

    func testInitialization() {
        let expectation = XCTNSPredicateExpectation(predicate: NSPredicate(block: { [weak self] _, _ in
            self?.viewModel.allKontests.count == 4 && self?.viewModel.toShowKontests.count == 3 && self?.viewModel.backupKontests.count == 3
        }), object: nil)
        wait(for: [expectation], timeout: 2)
    }

    func testFilterKontestsUsingSearchText() {
        let expectation1 = XCTNSPredicateExpectation(predicate: NSPredicate(block: { [weak self] _, _ in
            self?.viewModel.searchText = "LeetCode"
            return self?.viewModel.toShowKontests.count == 1
        }), object: nil)

        let expectation2 = XCTNSPredicateExpectation(predicate: NSPredicate(block: { [weak self] _, _ in
            self?.viewModel.searchText = "HackerEarth"
            return self?.viewModel.toShowKontests.count == 1
        }), object: nil)

        let expectation3 = XCTNSPredicateExpectation(predicate: NSPredicate(block: { [weak self] _, _ in
            self?.viewModel.searchText = "CodeForces"
            return self?.viewModel.toShowKontests.count == 1
        }), object: nil)

        wait(for: [expectation1, expectation2, expectation3], timeout: 2)
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

            KontestDTO(name: "Weekly Contest 358", url: "https://leetcode.com/contest/weekly-contest-358", start_time: startDateString, end_time: endDateString, duration: "5400", site: "LeetCode", in_24_hours: "Yes", status: "BEFORE"),

            KontestDTO(name: "CodeForces Round (Div. 2)", url: "https://codeforces.com/enter?back=%2FcontestRegistration%2F1871", start_time: startDateString, end_time: endDateString, duration: "\(86400 * 3)", site: "CodeForces", in_24_hours: "Yes", status: "CODING"),

            KontestDTO(name: "Hacker Earth Coding", url: "https://hackerearth.com/", start_time: startDateString, end_time: endDateString, duration: "\(86400 * 3)", site: "HackerEarth", in_24_hours: "Yes", status: "CODING")
        ]

        return allKontests
    }
}
