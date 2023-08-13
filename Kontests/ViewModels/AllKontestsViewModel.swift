//
//  AllKontestsViewModel.swift
//  Kontests
//
//  Created by Ayush Singhal on 12/08/23.
//

import SwiftUI

@Observable
class AllKontestsViewModel {
    var allKontests: [Kontest] = []
    let repository = KontestRepository()

    static let instance = AllKontestsViewModel() // Singleton instance

    private init() {
        Task {
            await getAllKontests()
        }
    }

    func getAllKontests() async {
        do {
            let fetchedKontests = try await repository.getAllKontests()

            await MainActor.run {
                self.allKontests = fetchedKontests.filter { kontest in
                    let kontestDuration = DateUtility.getFormattedDuration(fromSeconds: kontest.duration) ?? ""
                    let kontestEndDate = DateUtility.getDate(date: kontest.end_time)
                    let isKontestEnded = DateUtility.isKontestOfPast(kontestEndDate: kontestEndDate ?? Date())

                    return !kontestDuration.isEmpty && !isKontestEnded
                }
            }
        } catch {
            print("error in fetching all Kontests: \(error)")
        }
    }

    func setNotification(title: String, subtitle: String, body: String, kontestStartDate: Date?) {
        let notificationDate = DateUtility.getTimeBefore(originalDate: kontestStartDate ?? Date(), minutes: 10, hours: 0)

        NotificationManager.instance.shecduleCalendarNotification(notificationContent: NotificationManager.NotificationContent(title: title, subtitle: subtitle, body: body, date: notificationDate))
    }

    func setNotification(kontest: Kontest) {
        let kontestStartDate = DateUtility.getDate(date: kontest.start_time)
        let notificationDate = DateUtility.getTimeBefore(originalDate: kontestStartDate ?? Date(), minutes: 10, hours: 0)

        NotificationManager.instance.shecduleCalendarNotification(notificationContent: NotificationManager.NotificationContent(title: kontest.name, subtitle: kontest.site, body: "Kontest is on \(kontest.start_time)", date: notificationDate), id: kontest.id)
    }

    func setNotificationForAllKontests() {
        for kontest in allKontests {
            setNotification(kontest: kontest)
        }
    }

    func removeAllPendingNotifications() {
        NotificationManager.instance.removeAllPendingNotifications()
    }

    func getAllPendingNotifications() {
        NotificationManager.instance.getAllPendingNotifications()
    }
}
