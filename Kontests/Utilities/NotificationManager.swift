//
//  NotificationManager.swift
//  Kontests
//
//  Created by Ayush Singhal on 13/08/23.
//

import UserNotifications

class NotificationManager {
    static let instance = NotificationManager() // singleton
    private init() {}

    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { _, error in
            if let error {
                print("ERROR: \(error)")
            } else {
                print("Success")
            }
        }
    }

    func shecduleCalendarNotifications(title: String, subtitle: String, body: String, date: Date) {
        let calendarNotificationContent = UNMutableNotificationContent()
        calendarNotificationContent.title = title
        calendarNotificationContent.subtitle = subtitle
        calendarNotificationContent.body = body
        calendarNotificationContent.badge = 1

        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)

        let calendarTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let calendarNotificationRequest = UNNotificationRequest(identifier: UUID().uuidString, content: calendarNotificationContent, trigger: calendarTrigger)

        UNUserNotificationCenter.current().add(calendarNotificationRequest)
    }
}
