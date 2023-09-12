//
//  GetKontests.swift
//  Kontest
//
//  Created by Ayush Singhal on 12/09/23.
//

import Foundation

class GetKontests {
    static func getKontests() async -> (fetchedKontests: [KontestModel], error: Error?) {
        let repository = KontestRepository()

        do {
            let fetchedKontests = try await repository.getAllKontests()

            return (fetchedKontests
                .map { dto in
                    let kontest = KontestModel.from(dto: dto)
                    // Load Reminder status
                    kontest.loadReminderStatus()
                    return kontest
                }
                .filter { kontest in
                    let kontestDuration = CalendarUtility.getFormattedDuration(fromSeconds: kontest.duration) ?? ""
                    let kontestEndDate = CalendarUtility.getDate(date: kontest.end_time)
                    let isKontestEnded = CalendarUtility.isKontestOfPast(kontestEndDate: kontestEndDate ?? Date())

                    return !kontestDuration.isEmpty && !isKontestEnded
                }, nil)
        } catch {
            print("error in fetching all Kontests: \(error)")
            return ([], error)
        }
    }

    static func getKontestsDividedIncategories() async -> (ongoingKontests: [KontestModel], laterTodayKontests: [KontestModel], tomorrowKontests: [KontestModel], laterKontests: [KontestModel], error: Error?) {
        let today = Date()
        let tomorrow = CalendarUtility.getTomorrow()
        let dayAfterTomorrow = CalendarUtility.getDayAfterTomorrow()

        let allKontestsWithError = await GetKontests.getKontests()
        let allKontests = allKontestsWithError.fetchedKontests
        let error = allKontestsWithError.error

        let ongoingKontests = allKontests.filter { CalendarUtility.isKontestRunning(kontestStartDate: CalendarUtility.getDate(date: $0.start_time) ?? today, kontestEndDate: CalendarUtility.getDate(date: $0.end_time) ?? today) }

        let laterTodayKontests = allKontests.filter {
            CalendarUtility.getDate(date: $0.start_time) ?? today < tomorrow && !(ongoingKontests.contains($0))
        }

        let tomorrowKontests = allKontests.filter { (CalendarUtility.getDate(date: $0.start_time) ?? today >= tomorrow) && (CalendarUtility.getDate(date: $0.start_time) ?? today < dayAfterTomorrow) }

        let laterKontests = allKontests.filter {
            CalendarUtility.getDate(date: $0.start_time) ?? today >= dayAfterTomorrow
        }

        var ans: ([KontestModel], [KontestModel], [KontestModel], [KontestModel], Error?)
        ans = (ongoingKontests, laterTodayKontests, tomorrowKontests, laterKontests, error)
        return ans
    }
}
