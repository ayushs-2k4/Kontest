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
    @Environment(ErrorState.self) private var errorState

    var body: some View {
        Menu {
            Button("Set notification for 10 mins, 30 mins, 1 hr, 6 hrs before") {
                Task {
                    do {
                        try await setNotificationForAllKontestsAtAllTimes()

                        showNotificationForAllKontestsAlert = true
                        showNotificationForAllKontestsAlertTitle = "Notification set for all the kontests 10 mins, 30 mins, 1 hr, 6 hrs before"
                    } catch {
                        errorState.errorWrapper = ErrorWrapper(error: error, guidance: "Please provide Notification Permission in order to set notifications")
                    }
                }
            }
            .help("Set Notification for all the following kontests 10 mins, 30 mins, 1 hr, 6 hrs before") // Tooltip text

            Button("Set notification for 10 minutes before") {
                setNotificationForAllKontests(minutesBefore: 10, hoursBefore: 0, daysBefore: 0)
            }
            .help("Set Notification for all the following kontests 10 minutes before") // Tooltip text

            Button("Set notification for 30 minutes before") {
                setNotificationForAllKontests(minutesBefore: 30, hoursBefore: 0, daysBefore: 0)
            }
            .help("Set Notification for all the following kontests 30 minutes before") // Tooltip text

            Button("Set notification for 1 hour before") {
                setNotificationForAllKontests(minutesBefore: 0, hoursBefore: 1, daysBefore: 0)
            }
            .help("Set Notification for all the following kontests 1 hour before") // Tooltip text

            Button("Set notification for 6 hours before") {
                setNotificationForAllKontests(minutesBefore: 0, hoursBefore: 6, daysBefore: 0)
            }
            .help("Set Notification for all the following kontests 6 hours before") // Tooltip text
        } label: {
            Image(systemName: "bell.fill")
        }
        .alert(showNotificationForAllKontestsAlertTitle, isPresented: $showNotificationForAllKontestsAlert, actions: {})
    }
}

extension AllNotificationMenu {
    func setNotificationForAllKontestsAtAllTimes() async throws {
        try await notificationsViewModel.setNotificationForAllKontests(minutesBefore: 10, hoursBefore: 0, daysBefore: 0)

        try await notificationsViewModel.setNotificationForAllKontests(minutesBefore: 30, hoursBefore: 0, daysBefore: 0)

        try await notificationsViewModel.setNotificationForAllKontests(minutesBefore: 0, hoursBefore: 1, daysBefore: 0)

        try await notificationsViewModel.setNotificationForAllKontests(minutesBefore: 0, hoursBefore: 6, daysBefore: 0)
    }
}

extension AllNotificationMenu {
    func setNotificationForAllKontests(minutesBefore: Int, hoursBefore: Int, daysBefore: Int) {
        Task {
            do {
                try await notificationsViewModel.setNotificationForAllKontests(minutesBefore: minutesBefore, hoursBefore: hoursBefore, daysBefore: daysBefore)

                showNotificationForAllKontestsAlert = true
                showNotificationForAllKontestsAlertTitle = "Notification set for all the kontests \(notificationDescription(minutesBefore: minutesBefore, hoursBefore: hoursBefore))"
            } catch {
                errorState.errorWrapper = ErrorWrapper(error: error, guidance: "Please provide Notification Permission in order to set notifications")
            }
        }
    }

    func notificationDescription(minutesBefore: Int, hoursBefore: Int) -> String {
        if hoursBefore > 0 {
            if hoursBefore == 1 {
                return "\(hoursBefore) hour before"
            } else {
                return "\(hoursBefore) hours before"
            }
        } else {
            return "\(minutesBefore) minutes before"
        }
    }
}

#Preview {
    AllNotificationMenu()
        .environment(AllKontestsViewModel.instance)
}
