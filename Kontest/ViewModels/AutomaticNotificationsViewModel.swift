//
//  AutomaticNotificationsViewModel.swift
//  Kontest
//
//  Created by Ayush Singhal on 2/20/24.
//

import Foundation
import OSLog

@Observable
class AutomaticNotificationsViewModel {
    static let instance = AutomaticNotificationsViewModel()

    private init() {}

    private let allKontestsViewModel: AllKontestsViewModel = Dependencies.instance.allKontestsViewModel
    private let notificationViewModel = Dependencies.instance.notificationsViewModel

    func addAutomaticNotificationToEligibleSites() async {
        let userDefaults = UserDefaults(suiteName: Constants.userDefaultsGroupID)!

        for siteAbbreviation in getAllSiteAbbreviations() {
            let newKey = siteAbbreviation + Constants.automaticNotificationSuffix

            if userDefaults.bool(forKey: newKey) == true {
                await addAutomaticNotifications(siteAbbreviation: siteAbbreviation)
            }
        }
    }

    func addAutomaticCalendarEventToEligibleSites() async {
        let userDefaults = UserDefaults(suiteName: Constants.userDefaultsGroupID)!

        for siteAbbreviation in getAllSiteAbbreviations() {
            let newKey = siteAbbreviation + Constants.automaticCalendarEventSuffix

            if userDefaults.bool(forKey: newKey) == true {
                await addAutomaticCalendarEvent(siteAbbreviation: siteAbbreviation)
            }
        }
    }

    private func addAutomaticNotifications(siteAbbreviation: String) async {
        let logger = Logger(subsystem: "com.ayushsinghal.Kontest", category: "addAutomaticNotifications")

        let toShowKontests = allKontestsViewModel.toShowKontests

        for kontestModel in toShowKontests {
            if kontestModel.siteAbbreviation == siteAbbreviation {
                if !kontestModel.isSetForReminder10MiutesBefore {
                    do {
                        try await notificationViewModel.setNotificationForKontest(kontest: kontestModel, minutesBefore: 10, hoursBefore: 0, daysBefore: 0)
                    } catch {
                        logger.error("Error in adding automatic notification to kontest: \("\(kontestModel)") with error: \(error)")
                    }
                }
            }
        }
    }

    private func addAutomaticCalendarEvent(siteAbbreviation: String) async {
        let logger = Logger(subsystem: "com.ayushsinghal.Kontest", category: "addAutomaticCalendarEvent")

        let toShowKontests = allKontestsViewModel.toShowKontests

        for kontestModel in toShowKontests {
            if kontestModel.siteAbbreviation == siteAbbreviation {
                if !kontestModel.isCalendarEventAdded {
                    let kontestStartDate = CalendarUtility.getDate(date: kontestModel.start_time)
                    let kontestEndDate = CalendarUtility.getDate(date: kontestModel.end_time)

                    if let kontestStartDate, let kontestEndDate {
                        do {
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
                        } catch {
                            logger.error("Error in adding automatic calendar event to kontest: \("\(kontestModel)") with error: \(error)")
                        }
                    }
                }
            }
        }
    }
}
