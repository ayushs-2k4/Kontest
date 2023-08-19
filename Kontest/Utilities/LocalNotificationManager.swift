//
//  NotificationManager.swift
//  Kontest
//
//  Created by Ayush Singhal on 13/08/23.
//

import UserNotifications

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        NSLog("NSLOG: UserInfo: \(userInfo)")

        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
}

class LocalNotificationManager {
    static let instance = LocalNotificationManager() // singleton
    let center = UNUserNotificationCenter.current()
    private var delegate: NotificationDelegate = .init()

    private init() {
        center.delegate = delegate
    }

    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        center.requestAuthorization(options: options) { _, error in
            if let error {
                print("ERROR: \(error)")
            } else {
                print("Success")
            }
        }
    }

    func scheduleIntervalNotification(id: String = UUID().uuidString) {
        let timedNotificationContent = UNMutableNotificationContent()
        timedNotificationContent.title = "This is my Timed notification"
        timedNotificationContent.subtitle = "This was sooo easy!"
        timedNotificationContent.body = "This is notification body"
        timedNotificationContent.sound = .default
        timedNotificationContent.badge = 1
        timedNotificationContent.userInfo = ["nextViewInterval": "loadingViewInterval"]

//        let userInfo: [AnyHashable: Any] = ["nextViewInterval": "loadingViewInterval"]

        // time
        let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let timeNotificationRequest = UNNotificationRequest(identifier: id, content: timedNotificationContent, trigger: timeTrigger)
        print("Scheduled Timed notification of after 5 seconds")

        center.add(timeNotificationRequest)
    }

    func scheduleCalendarNotification(notificationContent: NotificationContent, id: String = UUID().uuidString) {
        checkNotificationPermissionGranted()

        let calendarNotificationContent = UNMutableNotificationContent()
        calendarNotificationContent.title = notificationContent.title
        calendarNotificationContent.subtitle = notificationContent.subtitle
        calendarNotificationContent.body = notificationContent.body
        calendarNotificationContent.sound = .default
        calendarNotificationContent.badge = 1

        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .timeZone, .hour, .minute], from: notificationContent.date)

//        let calendarNotificationContentAction = UNNotificationAction(identifier: id, title: "View Contest")
        let userInfo: [AnyHashable: Any] = ["nextView": "loadingView"]
        calendarNotificationContent.userInfo = userInfo

        let calendarTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let calendarNotificationRequest = UNNotificationRequest(identifier: id, content: calendarNotificationContent, trigger: calendarTrigger)

        print("Notification setted for: \(notificationContent.date)")

        center.add(calendarNotificationRequest)
    }

    func checkNotificationPermissionGranted() {
        center.getNotificationSettings { settings in
            if settings.authorizationStatus != .authorized {
                self.requestAuthorization()
            }
        }
    }

    func setBadgeCountTo0() {
        center.setBadgeCount(0)
    }

    func printAllPendingNotifications() {
        print("printing notifs")
        center.getPendingNotificationRequests { requests in
            print("requests.count: \(requests.count)")
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

    func getAllPendingNotifications(completion: @escaping ([UNNotificationRequest]) -> Void) {
        var ans: [UNNotificationRequest] = []
        center.getPendingNotificationRequests { requests in
            print("requests.count2: \(requests.count)")
            ans.append(contentsOf: requests)
            print("ans.count: \(ans.count)")
            completion(ans)
        }
    }

    func removeAllPendingNotifications() {
        center.removeAllPendingNotificationRequests()
    }

    func removePendingNotification(identifiers: [String]) {
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }

    func shecduleCalendarNotifications(notifications: [NotificationContent]) {
        for notification in notifications {
            scheduleCalendarNotification(notificationContent: notification)
        }
    }

    struct NotificationContent {
        let title: String
        let subtitle: String
        let body: String
        let date: Date
    }
}
