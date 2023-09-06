//
//  AllKontestsViewModel.swift
//  Kontest
//
//  Created by Ayush Singhal on 12/08/23.
//

import Combine
import SwiftUI

@Observable
class AllKontestsViewModel {
    let repository = AllKontestsFakeRepository()

    private var timer: AnyCancellable?

    private(set) var allKontests: [KontestModel] = []
    private(set) var ongoingKontests: [KontestModel] = []
    private(set) var laterTodayKontests: [KontestModel] = []
    private(set) var tomorrowKontests: [KontestModel] = []
    private(set) var laterKontests: [KontestModel] = []

    var searchText: String = "" {
        didSet {
            updateFilteredKontests()
        }
    }

    var isLoading = false

    private(set) var backupKontests: [KontestModel] = []

    init() {
        fetchAllKontests()
    }

    func fetchAllKontests() {
        isLoading = true
        Task {
            await getAllKontests()
            filterKontests()
            isLoading = false
            backupKontests = allKontests
            removeReminderStatusFromUserDefaults()

            self.timer = Timer.publish(every: 1, on: .main, in: .default)
                .autoconnect()
                .sink { [weak self] _ in
                    self?.filterKontests()
                }
        }
    }

    private func getAllKontests() async {
        do {
            let fetchedKontests = try await repository.getAllKontests()

            await MainActor.run {
                self.allKontests = fetchedKontests
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
                    }
            }
        } catch {
            print("error in fetching all Kontests: \(error)")
        }
    }

    private func setNotification(kontest: KontestModel, minutesBefore: Int = Constants.minutesToBeReminderBefore, hoursBefore: Int = 0, daysBefore: Int = 0, kontestTitle: String, kontestSubTitle: String, kontestBody: String) {
        let kontestStartDate = CalendarUtility.getDate(date: kontest.start_time)
        let notificationDate = CalendarUtility.getTimeBefore(originalDate: kontestStartDate ?? Date(), minutes: minutesBefore, hours: hoursBefore, days: daysBefore)
        let notificationID = kontest.id + CalendarUtility.getKontestDate(date: notificationDate) + CalendarUtility.getTimeFromDate(date: notificationDate)

        LocalNotificationManager.instance.scheduleCalendarNotification(notificationContent: LocalNotificationManager.NotificationContent(title: kontestTitle, subtitle: kontestSubTitle, body: kontestBody, date: notificationDate), id: notificationID)

        updateIsSetForNotification(kontest: kontest, to: true, minutesBefore: minutesBefore, hoursBefore: hoursBefore)
    }

    func setNotificationForKontest(kontest: KontestModel, minutesBefore: Int = Constants.minutesToBeReminderBefore, hoursBefore: Int = 0, daysBefore: Int = 0, kontestTitle: String = "", kontestSubTitle: String = "", kontestBody: String = "") {
        let kontestStartDate = CalendarUtility.getDate(date: kontest.start_time)

        // Checking if we actually have given time in starting of kontest; like if given 6 hours, then checking if we actually have 6 hours or not in starting of kontest.
        if CalendarUtility.isRemainingTimeGreaterThanGivenTime(date: kontestStartDate, minutes: minutesBefore, hours: hoursBefore, days: daysBefore) {
            let title = kontestTitle == "" ? kontest.name : kontestTitle
            let subTitle = kontestSubTitle == "" ? kontest.site : kontestSubTitle
            var body = ""
            if hoursBefore > 0 {
                if hoursBefore == 1 {
                    body = kontestBody == "" ? "\(kontest.name) is starting in \(hoursBefore) hour." : kontestBody
                } else {
                    body = kontestBody == "" ? "\(kontest.name) is starting in \(hoursBefore) hours." : kontestBody
                }
            } else {
                body = kontestBody == "" ? "\(kontest.name) is starting in \(minutesBefore) minutes." : kontestBody
            }

            setNotification(kontest: kontest, minutesBefore: minutesBefore, hoursBefore: hoursBefore, daysBefore: daysBefore, kontestTitle: title, kontestSubTitle: subTitle, kontestBody: body)
        }
    }

    func setNotificationForAllKontests(minutesBefore: Int = Constants.minutesToBeReminderBefore, hoursBefore: Int = 0, daysBefore: Int = 0, kontestTitle: String = "", kontestSubTitle: String = "", kontestBody: String = "") {
        for i in 0 ..< allKontests.count {
            let kontest = allKontests[i]
            let kontestStartDate = CalendarUtility.getDate(date: kontest.start_time)

            if CalendarUtility.isKontestOfFuture(kontestStartDate: kontestStartDate ?? Date()) {
                setNotificationForKontest(kontest: kontest, minutesBefore: minutesBefore, hoursBefore: hoursBefore, daysBefore: daysBefore, kontestTitle: kontestTitle, kontestSubTitle: kontestSubTitle, kontestBody: kontestBody)
            }
        }
    }

    func removeAllPendingNotifications() {
        LocalNotificationManager.instance.removeAllPendingNotifications()
        for i in 0 ..< allKontests.count {
            updateIsSetForNotification(kontest: allKontests[i], to: false, removeAll: true)
        }
    }

    func removePendingNotification(kontest: KontestModel, minutesBefore: Int = Constants.minutesToBeReminderBefore, hoursBefore: Int = 0, daysBefore: Int = 0) {
        let kontestStartDate = CalendarUtility.getDate(date: kontest.start_time)
        let notificationDate = CalendarUtility.getTimeBefore(originalDate: kontestStartDate ?? Date(), minutes: minutesBefore, hours: hoursBefore, days: daysBefore)
        let notificationID = kontest.id + CalendarUtility.getKontestDate(date: notificationDate) + CalendarUtility.getTimeFromDate(date: notificationDate)
        LocalNotificationManager.instance.removePendingNotification(identifiers: [notificationID])
        updateIsSetForNotification(kontest: kontest, to: false, minutesBefore: minutesBefore, hoursBefore: hoursBefore, daysBefore: daysBefore)
    }

    func printAllPendingNotifications() {
        LocalNotificationManager.instance.printAllPendingNotifications()
    }

    func updateIsSetForNotification(kontest: KontestModel, to: Bool, minutesBefore: Int = Constants.minutesToBeReminderBefore, hoursBefore: Int = 0, daysBefore: Int = 0, removeAll: Bool = false) {
        if to == false {
            if removeAll == true {
                if let index = allKontests.firstIndex(where: { $0 == kontest }) {
                    allKontests[index].isSetForReminder10MiutesBefore = false
                    allKontests[index].isSetForReminder30MiutesBefore = false
                    allKontests[index].isSetForReminder1HourBefore = false
                    allKontests[index].isSetForReminder6HoursBefore = false

                    allKontests[index].saveReminderStatus(minutesBefore: minutesBefore, hoursBefore: hoursBefore, daysBefore: daysBefore)
                }
            } else {
                if let index = allKontests.firstIndex(where: { $0 == kontest }) {
                    if minutesBefore == 10 {
                        allKontests[index].isSetForReminder10MiutesBefore = to
                    } else if minutesBefore == 30 {
                        allKontests[index].isSetForReminder30MiutesBefore = to
                    } else if hoursBefore == 1 {
                        allKontests[index].isSetForReminder1HourBefore = to
                    } else {
                        allKontests[index].isSetForReminder6HoursBefore = to
                    }

                    allKontests[index].saveReminderStatus(minutesBefore: minutesBefore, hoursBefore: hoursBefore, daysBefore: daysBefore)
                }
            }
        } else {
            if let index = allKontests.firstIndex(where: { $0 == kontest }) {
                if minutesBefore == 10 {
                    allKontests[index].isSetForReminder10MiutesBefore = to
                } else if minutesBefore == 30 {
                    allKontests[index].isSetForReminder30MiutesBefore = to
                } else if hoursBefore == 1 {
                    allKontests[index].isSetForReminder1HourBefore = to
                } else {
                    allKontests[index].isSetForReminder6HoursBefore = to
                }

                allKontests[index].saveReminderStatus(minutesBefore: minutesBefore, hoursBefore: hoursBefore, daysBefore: daysBefore)
            }
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
        if let formattedKontestEndDate = CalendarUtility.getDate(date: kontestEndDate) {
            return formattedKontestEndDate < currentDate
        }

        return true
    }

    func filterKontests() {
        let today = Date()
        let tomorrow = CalendarUtility.getTomorrow()
        let dayAfterTomorrow = CalendarUtility.getDayAfterTomorrow()
        withAnimation {
            allKontests = allKontests.filter {
                !CalendarUtility.isKontestOfPast(kontestEndDate: CalendarUtility.getDate(date: $0.end_time) ?? Date())
            }

            ongoingKontests = allKontests.filter { CalendarUtility.isKontestRunning(kontestStartDate: CalendarUtility.getDate(date: $0.start_time) ?? today, kontestEndDate: CalendarUtility.getDate(date: $0.end_time) ?? today) }

            laterTodayKontests = allKontests.filter {
                let startDate = CalendarUtility.getDate(date: $0.start_time) ?? today
                let bool1 = startDate < tomorrow
                let bool2 = ongoingKontests.contains($0)
                let k = bool1 && !bool2
                return k
            }

            tomorrowKontests = allKontests.filter { (CalendarUtility.getDate(date: $0.start_time) ?? today >= tomorrow) && (CalendarUtility.getDate(date: $0.start_time) ?? today < dayAfterTomorrow) }

            laterKontests = allKontests.filter {
                CalendarUtility.getDate(date: $0.start_time) ?? today >= dayAfterTomorrow
            }
        }
    }
}
