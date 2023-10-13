//
//  AllKontestsFakeRepository.swift
//  Kontest
//
//  Created by Ayush Singhal on 13/08/23.
//

import Foundation

class AllKontestsFakeRepository: KontestFetcher {
    func getAllKontests() async throws -> [KontestDTO] {
        var kontests: [KontestDTO] = []

        let startTime = "2023-08-15 18:31:00 UTC"
        let endTime = "2023-12-10 13:38:30 UTC"

//        let startTime = "2023-08-15 6:2:00 UTC"
//        let endTime = "2023-08-17 17:43:00 UTC"

        let startTime2 = "2023-09-6 08:50:00 UTC"
        let endTime2 = "2023-09-6 08:50:00 UTC"

//        let startTime3 = "2023-08-15 17:25:00 UTC"
//        let endTime3 = "2023-08-18 17:43:00 UTC"

        let startTime3 = "2023-08-15 18:31:00 UTC"
        let endTime3 = "2023-10-10 13:40:10 UTC"

        let allKontests: [KontestDTO] = [
            KontestDTO(name: "ProjectEuler+1", url: "https://hackerrank.com/contests/projecteuler", start_time: "2023-08-15 18:29:00 UTC", end_time: "2023-08-18 17:43:00 UTC", duration: "1020.0", site: "HackerRank", in_24_hours: "No", status: "BEFORE"),

            KontestDTO(name: "ProjectEuler+2", url: "https://hackerrank.com/contests/projecteuler", start_time: "2014-07-07T15:38:00.000Z", end_time: "2024-07-30T18:30:00.000Z", duration: "1020.0", site: "HackerRank", in_24_hours: "No", status: "BEFORE"),

            KontestDTO(name: "ProjectEuler+3", url: "https://hackerrank.com/contests/projecteuler", start_time: startTime, end_time: endTime, duration: "1020.0", site: "HackerRank", in_24_hours: "No", status: "BEFORE"),

            KontestDTO(name: "ProjectEuler+4", url: "https://hackerrank.com/contests/projecteuler", start_time: startTime2, end_time: endTime2, duration: "1020.0", site: "HackerRank", in_24_hours: "No", status: "BEFORE"),

            KontestDTO(name: "1v1 Games by CodeChef", url: "https://www.codechef.com/GAMES", start_time: "2022-10-10 06:30:00 UTC", end_time: "2032-10-10 06:30:00 UTC", duration: "315619200.0", site: "CodeChef", in_24_hours: "No", status: "CODING"),

            KontestDTO(name: "Weekly Contest 358", url: "https://leetcode.com/contest/weekly-contest-358", start_time: "2023-08-13T02:30:00.000Z", end_time: "2023-08-13T04:00:00.000Z", duration: "5400", site: "LeetCode", in_24_hours: "Yes", status: "BEFORE"),

            KontestDTO(name: "Starters 100 (Date to be decided)", url: "https://www.codechef.com/START100", start_time: "2023-08-30 14:30:00 UTC", end_time: "2023-08-30 16:30:00 UTC", duration: "7200", site: "CodeChef", in_24_hours: "No", status: "BEFORE"),

            KontestDTO(name: "Starters 100 (Date to be decided)", url: "https://www.codechef.com/START100", start_time: "2023-08-30 14:30:00 UTC", end_time: "2023-08-30 16:30:00 UTC", duration: "7200", site: "CodeChef", in_24_hours: "No", status: "CODING"),

            KontestDTO(name: "Test Contest 358", url: "https://leetcode.com/contest/weekly-contest-358", start_time: startTime, end_time: endTime, duration: "1800", site: "LeetCode", in_24_hours: "Yes", status: "BEFORE"),

            KontestDTO(name: "Test Contest 359", url: "https://leetcode.com/contest/weekly-contest-359", start_time: startTime, end_time: endTime, duration: "1800", site: "LeetCode", in_24_hours: "Yes", status: "CODING"),

            KontestDTO(name: "1v1 Games by CodeChef", url: "https://www.codechef.com/GAMES", start_time: "2022-10-10 06:30:00 UTC", end_time: "2032-10-10 06:30:00 UTC", duration: "315619200.0", site: "CodeChef", in_24_hours: "No", status: "CODING"),

            KontestDTO(name: "Weekly Contest 358", url: "https://leetcode.com/contest/weekly-contest-358", start_time: "2023-08-13T02:30:00.000Z", end_time: "2023-08-13T04:00:00.000Z", duration: "5400", site: "LeetCode", in_24_hours: "Yes", status: "BEFORE"),

            KontestDTO(name: "Test Contest", url: "https://leetcode.com/contest/weekly-contest-360", start_time: "2023-08-13T02:30:00.000Z", end_time: "2023-08-13T05:00:00.000Z", duration: "1800", site: "LeetCode", in_24_hours: "Yes", status: "BEFORE"),

            KontestDTO(name: "Test Contest", url: "https://leetcode.com/contest/weekly-contest-360", start_time: startTime3, end_time: endTime3, duration: "1800", site: "LeetCode", in_24_hours: "Yes", status: "BEFORE"),

            KontestDTO(name: "Starters 101 (Date to be decided)", url: "https://www.codechef.com/START101", start_time: "2023-08-30 14:30:00 UTC", end_time: "2023-08-30 16:30:00 UTC", duration: "7200", site: "CodeChef", in_24_hours: "No", status: "BEFORE")
        ]

        kontests.append(contentsOf: allKontests)

        return kontests
    }
}
