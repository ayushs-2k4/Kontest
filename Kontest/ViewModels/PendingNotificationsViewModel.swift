//
//  PendingNotificationsViewModel.swift
//  Kontest
//
//  Created by Ayush Singhal on 17/08/23.
//

import SwiftUI
import UserNotifications

@Observable
class PendingNotificationsViewModel {
    var pendingNotifications: [UNNotificationRequest] = []

    static let instance: PendingNotificationsViewModel = .init()

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

    func numberOfOptions(kontest: KontestModel) -> Int {
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
}
