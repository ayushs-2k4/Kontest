//
//  AllKontestsViewModel.swift
//  Kontests
//
//  Created by Ayush Singhal on 12/08/23.
//

import Combine
import SwiftUI

@Observable
class AllKontestsViewModel {
    let repository = KontestRepository()

    private var timer: AnyCancellable?

    var allKontests: [KontestModel] = []
    var searchText: String = "" {
        didSet {
            updateFilteredKontests()
        }
    }

    var isLoading = false

    private var backupKontests: [KontestModel] = []

    static let instance = AllKontestsViewModel() // Singleton instance

    private init() {
        isLoading = true
        Task {
            await getAllKontests()
            isLoading = false
            backupKontests = allKontests
            removeReminderStatusFromUserDefaults()

            self.timer = Timer.publish(every: 10, on: .main, in: .default)
                .autoconnect()
                .sink { [weak self] _ in
                    self?.updateKontestStatus()
                }
        }
    }

    func getAllKontests() async {
        do {
            let fetchedKontests = try await repository.getAllKontests()

            await MainActor.run {
                self.allKontests = fetchedKontests
                    .map { dto in
                        var kontest = KontestModel.from(dto: dto)
                        // Load Reminder status
                        kontest.loadReminderStatus()
                        return kontest
                    }
                    .filter { kontest in
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

    func setNotification(kontest: KontestModel) {
        let kontestStartDate = DateUtility.getDate(date: kontest.start_time)
        let notificationDate = DateUtility.getTimeBefore(originalDate: kontestStartDate ?? Date(), minutes: 0, hours: 0)

        NotificationManager.instance.shecduleCalendarNotification(notificationContent: NotificationManager.NotificationContent(title: kontest.name, subtitle: kontest.site, body: "Kontest is on \(kontest.start_time)", date: notificationDate), id: kontest.id)

        updateIsSetForNotification(kontest: kontest, to: true)
    }

    func setNotificationForAllKontests() {
        for i in 0 ..< allKontests.count {
            setNotification(kontest: allKontests[i])

            allKontests[i].isSetForReminder = true
        }
    }

    func removeAllPendingNotifications() {
        NotificationManager.instance.removeAllPendingNotifications()
        for i in 0 ..< allKontests.count {
            updateIsSetForNotification(kontest: allKontests[i], to: false)
        }
    }

    func removePendingNotification(kontest: KontestModel) {
        NotificationManager.instance.removePendingNotification(identifiers: [kontest.id])
        updateIsSetForNotification(kontest: kontest, to: false)
    }

    func getAllPendingNotifications() {
        NotificationManager.instance.getAllPendingNotifications()
    }

    func updateIsSetForNotification(kontest: KontestModel, to: Bool) {
        if let index = allKontests.firstIndex(where: { $0 == kontest }) {
            allKontests[index].isSetForReminder = to
            allKontests[index].saveReminderStatus()
        }
    }

    private func updateFilteredKontests() {
        let filteredKontests = backupKontests
            .filter { kontest in
                kontest.name.localizedCaseInsensitiveContains(searchText) || kontest.site.localizedCaseInsensitiveContains(searchText) || kontest.url.localizedCaseInsensitiveContains(searchText)
            }

        // Update the filtered kontests
        allKontests = searchText.isEmpty ? backupKontests : filteredKontests
    }

    private func removeReminderStatusFromUserDefaults() {
        for kontest in allKontests {
            if isKontestEnded(kontestEndDate: kontest.end_time) {
                kontest.removeReminderStatusFromUserDefaults()
                print("kontest with id: \(kontest.id)'s notification is deleted as kontest is ended.")
            }
        }
    }

    private func isKontestEnded(kontestEndDate: String) -> Bool {
        let currentDate = Date()
        if let formattedKontestEndDate = DateUtility.getDate(date: kontestEndDate) {
            return formattedKontestEndDate < currentDate
        }

        return true
    }

    private func updateKontestStatus() {
        var indices: [Int] = []
        for i in 0 ..< allKontests.count {
            allKontests[i].status = allKontests[i].updateKontestStatus()

            if allKontests[i].status == .Ended {
                indices.append(i)
            }
        }

        let indexSet = IndexSet(indices)
        allKontests.remove(atOffsets: indexSet)
    }
}
