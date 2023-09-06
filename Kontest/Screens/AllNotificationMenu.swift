//
//  AllNotificationMenu.swift
//  Kontest
//
//  Created by Ayush Singhal on 23/08/23.
//

import SwiftUI

struct AllNotificationMenu: View {
    @State var showNotificationForAllKontestsAlert = false
    @State var showNotificationForAllKontestsAlertTitle = ""
    let notificationsViewModel = NotificationsViewModel.instance
    @Environment(AllKontestsViewModel.self) private var allKontestsViewModel

    var body: some View {
        Menu {
            Button("Set notification for 10 mins, 30 mins, 1 hr, 6 hrs before") {
                showNotificationForAllKontestsAlert = true
                showNotificationForAllKontestsAlertTitle = "Notification set for all the kontests 10 mins, 30 mins, 1 hr, 6 hrs before"

                setNotificationForAllKontestsAtAllTimes()
            }
            .help("Set Notification for all the following kontests 10 mins, 30 mins, 1 hr, 6 hrs before") // Tooltip text

            Button("Set notification for 10 minutes before") {
                showNotificationForAllKontestsAlert = true
                showNotificationForAllKontestsAlertTitle = "Notification set for all the kontests 10 minutes before"
                notificationsViewModel.setNotificationForAllKontests(minutesBefore: 10, hoursBefore: 0, daysBefore: 0)
            }
            .help("Set Notification for all the following kontests 10 minutes before") // Tooltip text

            Button("Set notification for 30 minutes before") {
                showNotificationForAllKontestsAlert = true
                showNotificationForAllKontestsAlertTitle = "Notification set for all the kontests 30 minutes before"
                notificationsViewModel.setNotificationForAllKontests(minutesBefore: 30, hoursBefore: 0, daysBefore: 0)
            }
            .help("Set Notification for all the following kontests 30 minutes before") // Tooltip text

            Button("Set notification for 1 hour before") {
                showNotificationForAllKontestsAlert = true
                showNotificationForAllKontestsAlertTitle = "Notification set for all the kontests 1 hour before"
                notificationsViewModel.setNotificationForAllKontests(minutesBefore: 0, hoursBefore: 1, daysBefore: 0)
            }
            .help("Set Notification for all the following kontests 1 hour before") // Tooltip text

            Button("Set notification for 6 hours before") {
                showNotificationForAllKontestsAlert = true
                showNotificationForAllKontestsAlertTitle = "Notification set for all the kontests 6 hours before"
                notificationsViewModel.setNotificationForAllKontests(minutesBefore: 0, hoursBefore: 6, daysBefore: 0)
            }
            .help("Set Notification for all the following kontests 6 hours before") // Tooltip text
        } label: {
            Image(systemName: "bell.fill")
        }
        .alert(showNotificationForAllKontestsAlertTitle, isPresented: $showNotificationForAllKontestsAlert, actions: {})
    }
}

extension AllNotificationMenu {
    func setNotificationForAllKontestsAtAllTimes() {
        notificationsViewModel.setNotificationForAllKontests(minutesBefore: 10, hoursBefore: 0, daysBefore: 0)

        notificationsViewModel.setNotificationForAllKontests(minutesBefore: 30, hoursBefore: 0, daysBefore: 0)

        notificationsViewModel.setNotificationForAllKontests(minutesBefore: 0, hoursBefore: 1, daysBefore: 0)

        notificationsViewModel.setNotificationForAllKontests(minutesBefore: 0, hoursBefore: 6, daysBefore: 0)
    }
}

#Preview {
    AllNotificationMenu()
        .environment(AllKontestsViewModel.instance)
}
