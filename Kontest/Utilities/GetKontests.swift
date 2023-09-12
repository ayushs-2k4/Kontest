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
}
