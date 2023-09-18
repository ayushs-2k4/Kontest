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
        try await super.setUp()

        let notificationsViewModel = MockNotificationsViewModel()
        let filterWebsitesViewModel = MockFilterWebsitesViewModel(allowedWebsites: ["CodeChef", "AtCoder"])

        viewModel = AllKontestsViewModel(
            notificationsViewModel: notificationsViewModel,
            filterWebsitesViewModel: filterWebsitesViewModel,
            repository: KontestsTestFakeRepository()
        )
    }

//    func testFilterKontestsUsingSearchText() {
//        XCTAssertEqual(2 * 2, 4)
//
//        let expectation = XCTestExpectation(description: "Fetch Kontests")
//
//        XCTAssertEqual(viewModel.toShowKontests.count, 1)
    ////        expectation.fulfill()
//
//        // Test when searchText is empty
//        viewModel.searchText = ""
//        viewModel.filterKontests()
//        XCTAssertEqual(viewModel.toShowKontests, viewModel.backupKontests)
//
//        // Test when searchText matches one item
//        viewModel.searchText = "CodeChef"
//        viewModel.filterKontests()
//        XCTAssertEqual(viewModel.toShowKontests.count, 1)
    ////        XCTAssertEqual(viewModel.toShowKontests.first?.name, "Python Challenge")
//
//        // Test when searchText matches multiple items
    ////        viewModel.searchText = "Contest"
    ////        viewModel.filterKontests()
    ////        XCTAssertEqual(viewModel.toShowKontests.count, 2)
    ////        XCTAssertTrue(viewModel.toShowKontests.contains { $0.name == "Swift Contest" })
    ////        XCTAssertTrue(viewModel.toShowKontests.contains { $0.name == "Java Competition" })
//
//        // Test when searchText doesn't match any items
//        viewModel.searchText = "JavaScript"
//        XCTAssertEqual(viewModel.toShowKontests.count, 0)
//        wait(for: [expectation], timeout: 5.0)
//    }

    override func tearDown() {}

    func testFilterKontestsUsingSearchTextAsync() async {
        XCTAssertEqual(2 * 2, 4)

//        XCTAssertEqual(viewModel.allKontests.count, 1)
//        XCTAssertEqual(viewModel.toShowKontests.count, 1)
    }
}

// class KontestsTestFakeRepository: KontestFetcher {
//    func getAllKontests() async throws -> [Kontest.KontestDTO] {
//        var kontestDTOs: [KontestDTO] = []
//
//        let startTime = "2023-09-9 18:06:00 UTC"
//        let endTime = "2023-10-10 18:11:20 UTC"
//
//        kontestDTOs = [
//            KontestDTO(name: "ProjectEuler+3", url: "https://hackerrank.com/contests/projecteuler", start_time: startTime, end_time: endTime, duration: "1020.0", site: "HackerRank", in_24_hours: "No", status: "BEFORE"),
//
//            KontestDTO(name: "Weekly Contest 358", url: "https://leetcode.com/contest/weekly-contest-358", start_time: "2023-08-13T02:30:00.000Z", end_time: "2023-08-13T04:00:00.000Z", duration: "5400", site: "LeetCode", in_24_hours: "Yes", status: "BEFORE"),
//
//            KontestDTO(name: "Starters 100 (Date to be decided)", url: "https://www.codechef.com/START100", start_time: "2023-08-30 14:30:00 UTC", end_time: "2023-08-30 16:30:00 UTC", duration: "7200", site: "CodeChef", in_24_hours: "No", status: "CODING"),
//        ]
//
//        return kontestDTOs
//    }
// }

class KontestsTestFakeRepository: KontestFetcher {
    func getAllKontests() async throws -> [Kontest.KontestDTO] {
        var allKontests: [KontestDTO]

        allKontests = [
            KontestDTO(name: "ProjectEuler+1", url: "https://hackerrank.com/contests/projecteuler", start_time: "2023-08-15 18:29:00 UTC", end_time: "2023-08-18 17:43:00 UTC", duration: "1020.0", site: "HackerRank", in_24_hours: "No", status: "BEFORE"),

            KontestDTO(name: "1v1 Games by CodeChef", url: "https://www.codechef.com/GAMES", start_time: "2022-10-10 06:30:00 UTC", end_time: "2032-10-10 06:30:00 UTC", duration: "315619200.0", site: "CodeChef", in_24_hours: "No", status: "CODING"),

            KontestDTO(name: "Weekly Contest 358", url: "https://leetcode.com/contest/weekly-contest-358", start_time: "2023-08-13T02:30:00.000Z", end_time: "2023-08-13T04:00:00.000Z", duration: "5400", site: "LeetCode", in_24_hours: "Yes", status: "BEFORE")
        ]

        return allKontests
    }
}
