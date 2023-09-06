//
//  NotificationsViewModel.swift
//  Kontest
//
//  Created by Ayush Singhal on 17/08/23.
//

import SwiftUI
import UserNotifications

@Observable
class NotificationsViewModel {
    var pendingNotifications: [UNNotificationRequest] = []

    static let instance: NotificationsViewModel = .init()

    private let allKontestsViewModel: AllKontestsViewModel

    private init() {
        self.allKontestsViewModel = AllKontestsViewModel.instance
        getAllPendingNotifications()
    }

    func getAllPendingNotifications() {
        print("ran")
        LocalNotificationManager.instance.getAllPendingNotifications(completion: { notifications in
            self.pendingNotifications = notifications.sorted(by: { firstNotificationRequest, secondNotificationRequest in
                let firstTrigger = firstNotificationRequest.trigger as? UNCalendarNotificationTrigger
                let firstTriggerTime = firstTrigger?.nextTriggerDate()

                let secondTrigger = secondNotificationRequest.trigger as? UNCalendarNotificationTrigger
                let secondTriggerTime = secondTrigger?.nextTriggerDate()

                return firstTriggerTime ?? Date() < secondTriggerTime ?? Date()
            })
        })
    }

    func getNumberOfNotificationsWhichCanBeSettedForAKontest(kontest: KontestModel) -> Int {
        var ans = 0
        let kontestStartDate = CalendarUtility.getDate(date: kontest.start_time)
        if kontestStartDate == nil {
            return 4
        }

        if CalendarUtility.isRemainingTimeGreaterThanGivenTime(date: kontestStartDate, minutes: 10, hours: 0, days: 0) {
            ans += 1
        }

        if CalendarUtility.isRemainingTimeGreaterThanGivenTime(date: kontestStartDate, minutes: 30, hours: 0, days: 0) {
            ans += 1
        }

        if CalendarUtility.isRemainingTimeGreaterThanGivenTime(date: kontestStartDate, minutes: 0, hours: 1, days: 0) {
            ans += 1
        }

        if CalendarUtility.isRemainingTimeGreaterThanGivenTime(date: kontestStartDate, minutes: 0, hours: 6, days: 0) {
            ans += 1
        }

        return ans
    }

    func getNumberOfSettedNotificationForAKontest(kontest: KontestModel) -> Int {
        var ans = 0
        let kontestStartDate = CalendarUtility.getDate(date: kontest.start_time)

        if !(CalendarUtility.isRemainingTimeGreaterThanGivenTime(date: kontestStartDate, minutes: 10) && !kontest.isSetForReminder10MiutesBefore) {
            ans += 1
        }

        if !(CalendarUtility.isRemainingTimeGreaterThanGivenTime(date: kontestStartDate, minutes: 30) && !kontest.isSetForReminder30MiutesBefore) {
            ans += 1
        }

        if !(CalendarUtility.isRemainingTimeGreaterThanGivenTime(date: kontestStartDate, hours: 1) && !kontest.isSetForReminder1HourBefore) {
            ans += 1
        }

        if !(CalendarUtility.isRemainingTimeGreaterThanGivenTime(date: kontestStartDate, hours: 6) && !kontest.isSetForReminder6HoursBefore) {
            ans += 1
        }

        return ans
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
        for i in 0 ..< allKontestsViewModel.allKontests.count {
            let kontest = allKontestsViewModel.allKontests[i]
            let kontestStartDate = CalendarUtility.getDate(date: kontest.start_time)

            if CalendarUtility.isKontestOfFuture(kontestStartDate: kontestStartDate ?? Date()) {
                setNotificationForKontest(kontest: kontest, minutesBefore: minutesBefore, hoursBefore: hoursBefore, daysBefore: daysBefore, kontestTitle: kontestTitle, kontestSubTitle: kontestSubTitle, kontestBody: kontestBody)
            }
        }
    }

    func removeAllPendingNotifications() {
        LocalNotificationManager.instance.removeAllPendingNotifications()
        for i in 0 ..< allKontestsViewModel.allKontests.count {
            updateIsSetForNotification(kontest: allKontestsViewModel.allKontests[i], to: false, removeAll: true)
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
                if let index = allKontestsViewModel.allKontests.firstIndex(where: { $0 == kontest }) {
                    allKontestsViewModel.allKontests[index].isSetForReminder10MiutesBefore = false
                    allKontestsViewModel.allKontests[index].isSetForReminder30MiutesBefore = false
                    allKontestsViewModel.allKontests[index].isSetForReminder1HourBefore = false
                    allKontestsViewModel.allKontests[index].isSetForReminder6HoursBefore = false

                    allKontestsViewModel.allKontests[index].saveReminderStatus(minutesBefore: minutesBefore, hoursBefore: hoursBefore, daysBefore: daysBefore)
                }
            } else {
                if let index = allKontestsViewModel.allKontests.firstIndex(where: { $0 == kontest }) {
                    if minutesBefore == 10 {
                        allKontestsViewModel.allKontests[index].isSetForReminder10MiutesBefore = to
                    } else if minutesBefore == 30 {
                        allKontestsViewModel.allKontests[index].isSetForReminder30MiutesBefore = to
                    } else if hoursBefore == 1 {
                        allKontestsViewModel.allKontests[index].isSetForReminder1HourBefore = to
                    } else {
                        allKontestsViewModel.allKontests[index].isSetForReminder6HoursBefore = to
                    }

                    allKontestsViewModel.allKontests[index].saveReminderStatus(minutesBefore: minutesBefore, hoursBefore: hoursBefore, daysBefore: daysBefore)
                }
            }
        } else {
            if let index = allKontestsViewModel.allKontests.firstIndex(where: { $0 == kontest }) {
                if minutesBefore == 10 {
                    allKontestsViewModel.allKontests[index].isSetForReminder10MiutesBefore = to
                } else if minutesBefore == 30 {
                    allKontestsViewModel.allKontests[index].isSetForReminder30MiutesBefore = to
                } else if hoursBefore == 1 {
                    allKontestsViewModel.allKontests[index].isSetForReminder1HourBefore = to
                } else {
                    allKontestsViewModel.allKontests[index].isSetForReminder6HoursBefore = to
                }

                allKontestsViewModel.allKontests[index].saveReminderStatus(minutesBefore: minutesBefore, hoursBefore: hoursBefore, daysBefore: daysBefore)
            }
        }
    }
}
