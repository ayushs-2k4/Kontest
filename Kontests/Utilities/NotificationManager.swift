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

    func shecduleIntervalNotifications() {
        let timedNotificationContent = UNMutableNotificationContent()
        timedNotificationContent.title = "This is my Timed notification"
        timedNotificationContent.subtitle = "This was sooo easy!"
        timedNotificationContent.body = "This is notification body"
        timedNotificationContent.sound = .default
        timedNotificationContent.badge = 1

        // time
        let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let timeNotificationRequest = UNNotificationRequest(identifier: UUID().uuidString, content: timedNotificationContent, trigger: timeTrigger)
        print("Scheduled Timed notification of after 5 seconds")

        UNUserNotificationCenter.current().add(timeNotificationRequest)
    }

    func shecduleCalendarNotifications(title: String, subtitle: String, body: String, date: Date) {
        checkNotificationPermissionGranted()

        let calendarNotificationContent = UNMutableNotificationContent()
        calendarNotificationContent.title = title
        calendarNotificationContent.subtitle = subtitle
        calendarNotificationContent.body = body
        calendarNotificationContent.badge = 1

        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)

        let calendarTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let calendarNotificationRequest = UNNotificationRequest(identifier: UUID().uuidString, content: calendarNotificationContent, trigger: calendarTrigger)

        print("Notification setted for: \(date)")

        UNUserNotificationCenter.current().add(calendarNotificationRequest)
    }

    func checkNotificationPermissionGranted() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            if settings.authorizationStatus != .authorized {
                self.requestAuthorization()
            }
        }
    }

    func setBadgeCountTo0() {
        UNUserNotificationCenter.current().setBadgeCount(0)
    }

    func getAllPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            for request in requests {
                print("Identifier: \(request.identifier)")
                print("Title: \(request.content.title)")
                print("Body: \(request.content.body)")
                if let trigger = request.trigger as? UNCalendarNotificationTrigger {
                    let date = trigger.nextTriggerDate()
                    print("Next Trigger Date: \(date ?? Date())")
                }
                print("-------")
            }
        }
    }

    func removeAllPendingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
