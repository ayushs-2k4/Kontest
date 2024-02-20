//
//  AutomaticNotificationsViewModel.swift
//  Kontest
//
//  Created by Ayush Singhal on 2/20/24.
//

import Foundation

@Observable
class AutomaticNotificationsViewModel {
    private let allKontestsViewModel: AllKontestsViewModel = Dependencies.instance.allKontestsViewModel
    private let notificationViewModel = Dependencies.instance.notificationsViewModel

    func addAutomaticNotifications(siteAbbreviation: String) {
        let toShowKontests = allKontestsViewModel.toShowKontests

        Task {
            for kontestModel in toShowKontests {
                if kontestModel.siteAbbreviation == siteAbbreviation {
                    if !kontestModel.isSetForReminder10MiutesBefore {
                        try await notificationViewModel.setNotificationForKontest(kontest: kontestModel, minutesBefore: 10, hoursBefore: 0, daysBefore: 0)
                    }
                }
            }
        }
    }

    func addAutomaticCalendarEvent(siteAbbreviation: String) {
        let toShowKontests = allKontestsViewModel.toShowKontests

        Task {
            for kontestModel in toShowKontests {
                if kontestModel.siteAbbreviation == siteAbbreviation {
                    if !kontestModel.isCalendarEventAdded {
                        let kontestStartDate = CalendarUtility.getDate(date: kontestModel.start_time)
                        let kontestEndDate = CalendarUtility.getDate(date: kontestModel.end_time)

                        if let kontestStartDate, let kontestEndDate {
                            if try await CalendarUtility.addEvent(
                                startDate: kontestStartDate,
                                endDate: kontestEndDate,
                                title: kontestModel.name,
                                notes: "",
                                url: URL(string: kontestModel.url),
                                alarmAbsoluteDate: kontestStartDate.addingTimeInterval(-15 * 60)
                            ) {
                                kontestModel.isCalendarEventAdded = true
                                kontestModel.calendarEventDate = kontestStartDate.addingTimeInterval(-15 * 60)
                            }
                        }
                    }
                }
            }
        }
    }
}
