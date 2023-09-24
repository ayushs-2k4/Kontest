//
//  GetKontests.swift
//  Kontest
//
//  Created by Ayush Singhal on 12/09/23.
//

import Foundation
import OSLog

class GetKontests {
    private static let logger = Logger(subsystem: "com.ayushsinghal.Kontest", category: "GetKontests")

    static func getKontests() async -> (fetchedKontests: [KontestModel], error: Error?) {
        let repository = KontestRepository()

        do {
            let fetchedKontests = try await repository.getAllKontests()
            let allEvents = try await CalendarUtility.getAllEvents()

            return (fetchedKontests
                .map { dto in
                    let kontest = KontestModel.from(dto: dto)
                    // Load Reminder status
                    kontest.loadReminderStatus()
                    kontest.loadCalendarStatus(allEvents: allEvents ?? [])
                    return kontest
                }
                .filter { kontest in
                    let kontestDuration = CalendarUtility.getFormattedDuration(fromSeconds: kontest.duration) ?? ""
                    let kontestEndDate = CalendarUtility.getDate(date: kontest.end_time)
                    let isKontestEnded = CalendarUtility.isKontestOfPast(kontestEndDate: kontestEndDate ?? Date())

                    return !kontestDuration.isEmpty && !isKontestEnded
                }, nil)
        } catch {
            logger.info("error in fetching all Kontests: \(error)")
            return ([], error)
        }
    }

    static func getKontestsDividedIncategories() async -> (
        allKontests: [KontestModel],
        filteredKontests: [KontestModel],
        ongoingKontests: [KontestModel],
        laterTodayKontests: [KontestModel],
        tomorrowKontests: [KontestModel],
        laterKontests: [KontestModel],
        error: Error?
    ) {
        let today = Date()

        let allKontestsWithError = await GetKontests.getKontests()
        let allKontests = allKontestsWithError.fetchedKontests
        let error = allKontestsWithError.error

        let filterWebsiteViewModel = FilterWebsitesViewModel()
        let allowedWebsites = filterWebsiteViewModel.getAllowedWebsites()

        let filteredKontests = allKontests.filter { allowedWebsites.contains($0.site) }

        let ongoingKontests = filteredKontests.filter { CalendarUtility.isKontestRunning(kontestStartDate: CalendarUtility.getDate(date: $0.start_time) ?? today, kontestEndDate: CalendarUtility.getDate(date: $0.end_time) ?? today) }

        let laterTodayKontests = filteredKontests.filter { CalendarUtility.isKontestLaterToday(kontestStartDate: CalendarUtility.getDate(date: $0.start_time) ?? Date()) }

        let tomorrowKontests = filteredKontests.filter { CalendarUtility.isKontestTomorrow(kontestStartDate: CalendarUtility.getDate(date: $0.start_time) ?? Date()) }

        let laterKontests = filteredKontests.filter { CalendarUtility.isKontestLater(kontestStartDate: CalendarUtility.getDate(date: $0.start_time) ?? Date()) }

        var ans: ([KontestModel], [KontestModel], [KontestModel], [KontestModel], [KontestModel], [KontestModel], Error?)
        ans = (allKontests, filteredKontests, ongoingKontests, laterTodayKontests, tomorrowKontests, laterKontests, error)
        return ans
    }
}
