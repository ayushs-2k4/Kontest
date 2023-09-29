//
//  SingleNotificationMenu.swift
//  Kontest
//
//  Created by Ayush Singhal on 23/08/23.
//

import SwiftUI

struct SingleNotificationMenu: View {
    var kontest: KontestModel
    @Environment(AllKontestsViewModel.self) private var allKontestsViewModel
    let notificationsViewModel = Dependencies.instance.notificationsViewModel
    @Environment(ErrorState.self) private var errorState

    var body: some View {
        let kontestStartDate = CalendarUtility.getDate(date: kontest.start_time)
        Menu {
            if notificationsViewModel.getNumberOfSettedNotificationForAKontest(kontest: kontest) <= 2 {
                Button {
                    setNotificationForAKontestAtAllTimes(kontest: kontest)
                } label: {
                    Image(systemName: "bell")
                    Text("Set all notifications for this kontest")
                }
                .help("Set Notification for this kontest 10 mins, 30 mins, 1 hr, 6 hrs before")
            }

            if notificationsViewModel.getNumberOfSettedNotificationForAKontest(kontest: kontest) >= 2 {
                Button {
                    removeAllNotificationForAKontest(kontest: kontest)
                } label: {
                    Image(systemName: "bell.slash")
                    Text("Remove all notification for this kontest")
                }
                .help("Remove All Notification for this kontest")
            }

            if CalendarUtility.isRemainingTimeGreaterThanGivenTime(date: kontestStartDate, minutes: 10, hours: 0, days: 0) {
                Button {
                    if kontest.isSetForReminder10MiutesBefore {
                        notificationsViewModel.removePendingNotification(kontest: kontest, minutesBefore: 10, hoursBefore: 0, daysBefore: 0)
                    } else {
                        setNotificationForKontest(kontest: kontest, minutesBefore: 10, hoursBefore: 0, daysBefore: 0)
                    }
                } label: {
                    Image(systemName: kontest.isSetForReminder10MiutesBefore ? "bell.fill" : "bell")
                    Text(kontest.isSetForReminder10MiutesBefore ? "Remove 10 minutes before notification" : "Set notification for 10 minutes before")
                }
                .help(kontest.isSetForReminder10MiutesBefore ? "Remove Notification for this kontest 10 minutes before" : "Set Notification for this kontest 10 minutes before") // Tooltip text
            }

            if CalendarUtility.isRemainingTimeGreaterThanGivenTime(date: kontestStartDate, minutes: 30, hours: 0, days: 0) {
                Button {
                    if kontest.isSetForReminder30MiutesBefore {
                        notificationsViewModel.removePendingNotification(kontest: kontest, minutesBefore: 30, hoursBefore: 0, daysBefore: 0)
                    } else {
                        setNotificationForKontest(kontest: kontest, minutesBefore: 30, hoursBefore: 0, daysBefore: 0)
                    }
                } label: {
                    Image(systemName: kontest.isSetForReminder30MiutesBefore ? "bell.fill" : "bell")
                    Text(kontest.isSetForReminder30MiutesBefore ? "Remove 30 minutes before notification" : "Set notification for 30 minutes before")
                }
                .help(kontest.isSetForReminder30MiutesBefore ? "Remove Notification for this kontest 30 minutes before" : "Set Notification for this kontest 30 minutes before") // Tooltip text
            }

            if CalendarUtility.isRemainingTimeGreaterThanGivenTime(date: kontestStartDate, minutes: 0, hours: 1, days: 0) {
                Button {
                    if kontest.isSetForReminder1HourBefore {
                        notificationsViewModel.removePendingNotification(kontest: kontest, minutesBefore: 0, hoursBefore: 1, daysBefore: 0)
                    } else {
                        setNotificationForKontest(kontest: kontest, minutesBefore: 0, hoursBefore: 1, daysBefore: 0)
                    }
                } label: {
                    Image(systemName: kontest.isSetForReminder1HourBefore ? "bell.fill" : "bell")
                    Text(kontest.isSetForReminder1HourBefore ? "Remove 1 hour before notification" : "Set notification for 1 hour before")
                }
                .help(kontest.isSetForReminder1HourBefore ? "Remove Notification for this kontest 1 hour before" : "Set Notification for this kontest 1 hour before") // Tooltip text
            }

            if CalendarUtility.isRemainingTimeGreaterThanGivenTime(date: kontestStartDate, minutes: 0, hours: 6, days: 0) {
                Button {
                    if kontest.isSetForReminder6HoursBefore {
                        notificationsViewModel.removePendingNotification(kontest: kontest, minutesBefore: 0, hoursBefore: 6, daysBefore: 0)
                    } else {
                        setNotificationForKontest(kontest: kontest, minutesBefore: 0, hoursBefore: 6, daysBefore: 0)
                    }
                } label: {
                    Image(systemName: kontest.isSetForReminder6HoursBefore ? "bell.fill" : "bell")
                    Text(kontest.isSetForReminder6HoursBefore ? "Remove 6 hours before notification" : "Set notification for 6 hours before")
                }
                .help(kontest.isSetForReminder6HoursBefore ? "Remove Notification for this kontest 6 hours before" : "Set Notification for this kontest 6 hours before") // Tooltip text
            }
        } label: {
            let imageName = isSetForAllNotifications(kontest: kontest) ? "bell.fill" : "bell"
            Image(systemName: imageName)
//                .frame(width: (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.screen.bounds.width)
        }
        .menuIndicator(.hidden)
    }
}

extension SingleNotificationMenu {
    func setNotificationForAKontestAtAllTimes(kontest: KontestModel) {
        Task {
            do {
                try await notificationsViewModel.setNotificationForKontest(kontest: kontest, minutesBefore: 10, hoursBefore: 0, daysBefore: 0)

                try await notificationsViewModel.setNotificationForKontest(kontest: kontest, minutesBefore: 30, hoursBefore: 0, daysBefore: 0)

                try await notificationsViewModel.setNotificationForKontest(kontest: kontest, minutesBefore: 0, hoursBefore: 1, daysBefore: 0)

                try await notificationsViewModel.setNotificationForKontest(kontest: kontest, minutesBefore: 0, hoursBefore: 6, daysBefore: 0)
            } catch {
                errorState.errorWrapper = ErrorWrapper(error: error, guidance: "Please provide Notification Permission in order to set notifications")
            }
        }
    }

    func isSetForAllNotifications(kontest: KontestModel) -> Bool {
        var ans = true
        let kontestStartDate = CalendarUtility.getDate(date: kontest.start_time)

        if (CalendarUtility.isRemainingTimeGreaterThanGivenTime(date: kontestStartDate, minutes: 10) && !kontest.isSetForReminder10MiutesBefore) || (CalendarUtility.isRemainingTimeGreaterThanGivenTime(date: kontestStartDate, minutes: 30) && !kontest.isSetForReminder30MiutesBefore) || (CalendarUtility.isRemainingTimeGreaterThanGivenTime(date: kontestStartDate, hours: 1) && !kontest.isSetForReminder1HourBefore) || (CalendarUtility.isRemainingTimeGreaterThanGivenTime(date: kontestStartDate, hours: 6) && !kontest.isSetForReminder6HoursBefore) {
            ans = false
        }

        return ans
    }

    func removeAllNotificationForAKontest(kontest: KontestModel) {
        notificationsViewModel.removePendingNotification(kontest: kontest, minutesBefore: 10, hoursBefore: 0, daysBefore: 0)
        notificationsViewModel.removePendingNotification(kontest: kontest, minutesBefore: 30, hoursBefore: 0, daysBefore: 0)
        notificationsViewModel.removePendingNotification(kontest: kontest, minutesBefore: 0, hoursBefore: 1, daysBefore: 0)
        notificationsViewModel.removePendingNotification(kontest: kontest, minutesBefore: 0, hoursBefore: 6, daysBefore: 0)
    }
}

extension SingleNotificationMenu {
    func setNotificationForKontest(kontest: KontestModel, minutesBefore: Int, hoursBefore: Int, daysBefore: Int) {
        Task {
            do {
                try await notificationsViewModel.setNotificationForKontest(kontest: kontest, minutesBefore: minutesBefore, hoursBefore: hoursBefore, daysBefore: daysBefore)

            } catch {
                errorState.errorWrapper = ErrorWrapper(error: error, guidance: "Please provide Notification Permission in order to set notifications")
            }
        }
    }
}

#Preview {
    SingleNotificationMenu(kontest: KontestModel.from(dto: KontestDTO(name: "ProjectEuler+1", url: "https://hackerrank.com/contests/projecteuler", start_time: "2023-08-15 18:29:00 UTC", end_time: "2023-08-18 17:43:00 UTC", duration: "1020.0", site: "HackerRank", in_24_hours: "No", status: "BEFORE")))
        .environment(Dependencies.instance.allKontestsViewModel)
}
