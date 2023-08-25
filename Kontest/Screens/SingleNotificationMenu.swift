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

    var body: some View {
        let kontestStartDate = CalendarUtility.getDate(date: kontest.start_time)
        Menu {
            if !isSetForAllNotifications(kontest: kontest) {
                Button {
                    setNotificationForAKontestAtAllTimes()
                } label: {
                    Image(systemName: "bell")
                    Text("Set notification for 10 mins, 30 mins, 1 hr, 6 hrs before")
                }
            }

            if CalendarUtility.isRemainingTimeGreaterThanGivenTime(date: kontestStartDate, minutes: 10, hours: 0, days: 0) {
                Button {
                    if kontest.isSetForReminder10MiutesBefore {
                        allKontestsViewModel.removePendingNotification(kontest: kontest, minutesBefore: 10, hoursBefore: 0, daysBefore: 0)
                    } else {
                        allKontestsViewModel.setNotificationForKontest(kontest: kontest, minutesBefore: 10, hoursBefore: 0, daysBefore: 0)
                    }
                } label: {
                    Image(systemName: kontest.isSetForReminder10MiutesBefore ? "bell.fill" : "bell")
                    Text(kontest.isSetForReminder10MiutesBefore ? "Remove 10 minutes before notification" : "Set notification for 10 minutes before")
                }
                .help("Set Notification for all the following kontests 10 minutes before") // Tooltip text
            }

            if CalendarUtility.isRemainingTimeGreaterThanGivenTime(date: kontestStartDate, minutes: 30, hours: 0, days: 0) {
                Button {
                    if kontest.isSetForReminder30MiutesBefore {
                        allKontestsViewModel.removePendingNotification(kontest: kontest, minutesBefore: 30, hoursBefore: 0, daysBefore: 0)
                    } else {
                        allKontestsViewModel.setNotificationForKontest(kontest: kontest, minutesBefore: 30, hoursBefore: 0, daysBefore: 0)
                    }
                } label: {
                    Image(systemName: kontest.isSetForReminder30MiutesBefore ? "bell.fill" : "bell")
                    Text(kontest.isSetForReminder30MiutesBefore ? "Remove 30 minutes before notification" : "Set notification for 30 minutes before")
                }
                .help("Set Notification for all the following kontests 30 minutes before") // Tooltip text
            }

            if CalendarUtility.isRemainingTimeGreaterThanGivenTime(date: kontestStartDate, minutes: 0, hours: 1, days: 0) {
                Button {
                    if kontest.isSetForReminder1HourBefore {
                        allKontestsViewModel.removePendingNotification(kontest: kontest, minutesBefore: 0, hoursBefore: 1, daysBefore: 0)
                    } else {
                        allKontestsViewModel.setNotificationForKontest(kontest: kontest, minutesBefore: 0, hoursBefore: 1, daysBefore: 0)
                    }
                } label: {
                    Image(systemName: kontest.isSetForReminder1HourBefore ? "bell.fill" : "bell")
                    Text(kontest.isSetForReminder1HourBefore ? "Remove 1 hour before notification" : "Set notification for 1 hour before")
                }
                .help("Set Notification for all the following kontests 1 hour before") // Tooltip text
            }

            if CalendarUtility.isRemainingTimeGreaterThanGivenTime(date: kontestStartDate, minutes: 0, hours: 6, days: 0) {
                Button {
                    if kontest.isSetForReminder6HoursBefore {
                        allKontestsViewModel.removePendingNotification(kontest: kontest, minutesBefore: 0, hoursBefore: 6, daysBefore: 0)
                    } else {
                        allKontestsViewModel.setNotificationForKontest(kontest: kontest, minutesBefore: 0, hoursBefore: 6, daysBefore: 0)
                    }
                } label: {
                    Image(systemName: kontest.isSetForReminder6HoursBefore ? "bell.fill" : "bell")
                    Text(kontest.isSetForReminder6HoursBefore ? "Remove 6 hours before notification" : "Set notification for 6 hours before")
                }
                .help("Set Notification for all the following kontests 6 hours before") // Tooltip text
            }
        } label: {
            let imageName = isSetForAllNotifications(kontest: kontest) ? "bell.fill" : "bell"
            Image(systemName: imageName)
//                .frame(width: (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.screen.bounds.width)
        }
    }
}

extension SingleNotificationMenu {
    func setNotificationForAKontestAtAllTimes() {
        let kontestStartDate = CalendarUtility.getDate(date: kontest.start_time)

        if CalendarUtility.isRemainingTimeGreaterThanGivenTime(date: kontestStartDate, minutes: 10, hours: 0, days: 0) {
            allKontestsViewModel.setNotificationForKontest(kontest: kontest, minutesBefore: 10, hoursBefore: 0, daysBefore: 0)
        }

        if CalendarUtility.isRemainingTimeGreaterThanGivenTime(date: kontestStartDate, minutes: 30, hours: 0, days: 0) {
            allKontestsViewModel.setNotificationForKontest(kontest: kontest, minutesBefore: 30, hoursBefore: 0, daysBefore: 0)
        }

        if CalendarUtility.isRemainingTimeGreaterThanGivenTime(date: kontestStartDate, minutes: 0, hours: 1, days: 0) {
            allKontestsViewModel.setNotificationForKontest(kontest: kontest, minutesBefore: 0, hoursBefore: 1, daysBefore: 0)
        }

        if CalendarUtility.isRemainingTimeGreaterThanGivenTime(date: kontestStartDate, minutes: 0, hours: 6, days: 0) {
            allKontestsViewModel.setNotificationForKontest(kontest: kontest, minutesBefore: 0, hoursBefore: 6, daysBefore: 0)
        }
    }

    func isSetForAllNotifications(kontest: KontestModel) -> Bool {
        return kontest.isSetForReminder10MiutesBefore && kontest.isSetForReminder30MiutesBefore && kontest.isSetForReminder1HourBefore && kontest.isSetForReminder6HoursBefore
    }
}

#Preview {
    SingleNotificationMenu(kontest: KontestModel.from(dto: KontestDTO(name: "ProjectEuler+1", url: "https://hackerrank.com/contests/projecteuler", start_time: "2023-08-15 18:29:00 UTC", end_time: "2023-08-18 17:43:00 UTC", duration: "1020.0", site: "HackerRank", in_24_hours: "No", status: "BEFORE")))
        .environment(AllKontestsViewModel())
}
