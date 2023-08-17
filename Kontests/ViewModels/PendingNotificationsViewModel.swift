//
//  PendingNotificationsViewModel.swift
//  Kontests
//
//  Created by Ayush Singhal on 17/08/23.
//

import SwiftUI
import UserNotifications

@Observable
class PendingNotificationsViewModel {
    var pendingNotifications: [UNNotificationRequest] = []

    init() {
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
}
