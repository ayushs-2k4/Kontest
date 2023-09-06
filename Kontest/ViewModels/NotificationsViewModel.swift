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

    private init() {
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
}
