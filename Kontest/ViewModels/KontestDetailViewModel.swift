//
//  KontestDetailViewModel.swift
//  Kontest
//
//  Created by Ayush Singhal on 06/09/23.
//

#if os(iOS)
import Combine
import OSLog
import SwiftUI

@Observable
class KontestDetailViewModel {
    private let logger = Logger(subsystem: "com.ayushsinghal.Kontest", category: "KontestDetailViewModel")

    let kontest: KontestModel
    var wasKontestRunning: Bool
    var isKontestRunning: Bool
    var isKontestOfFutureAndStartingInLessThan24Hours: Bool

    private var timer: AnyCancellable?

    init(kontest: KontestModel) {
        self.kontest = kontest

        let kontestStartDate = CalendarUtility.getDate(date: kontest.start_time)
        let kontestEndDate = CalendarUtility.getDate(date: kontest.end_time)
        isKontestRunning = CalendarUtility.isKontestRunning(kontestStartDate: kontestStartDate ?? Date(), kontestEndDate: kontestEndDate ?? Date()) || kontest.status == .OnGoing

        wasKontestRunning = CalendarUtility.isKontestRunning(kontestStartDate: kontestStartDate ?? Date(), kontestEndDate: kontestEndDate ?? Date()) || kontest.status == .OnGoing

        let isKontestOfFuture = CalendarUtility.isKontestOfFuture(kontestStartDate: kontestStartDate ?? Date())
        let isKontestStartingTimeLessThanADay = !(CalendarUtility.isRemainingTimeGreaterThanGivenTime(date: kontestStartDate, minutes: 0, hours: 0, days: 1))
        isKontestOfFutureAndStartingInLessThan24Hours = isKontestOfFuture && isKontestStartingTimeLessThanADay

        timer = Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateKontestStatus()
            }

        do {
            try addCalendarObserver()
        } catch {
            logger.info("Can not add observer to Calendar with error: \(error)")
        }
    }

    private func updateKontestStatus() {
        let kontestStartDate = CalendarUtility.getDate(date: kontest.start_time)
        let kontestEndDate = CalendarUtility.getDate(date: kontest.end_time)
        isKontestRunning = CalendarUtility.isKontestRunning(kontestStartDate: kontestStartDate ?? Date(), kontestEndDate: kontestEndDate ?? Date())

        let isKontestOfFuture = CalendarUtility.isKontestOfFuture(kontestStartDate: kontestStartDate ?? Date())
        let isKontestStartingTimeLessThanADay = !(CalendarUtility.isRemainingTimeGreaterThanGivenTime(date: kontestStartDate, minutes: 0, hours: 0, days: 1))
        isKontestOfFutureAndStartingInLessThan24Hours = isKontestOfFuture && isKontestStartingTimeLessThanADay
    }

    private func addCalendarObserver() throws {
        if CalendarUtility.getAuthorizationStatus() == .fullAccess {
            CalendarUtility.addCalendarObserver(onChange: { [weak self] _ in
                guard let self else { return }

                Task {
                    print("swacd")
                    let allEvents = try await CalendarUtility.getAllEvents()
                    print("swacd2")

                    self.kontest.loadCalendarStatus(allEvents: allEvents ?? [])
                    self.kontest.loadCalendarEventDate(allEvents: allEvents ?? [])
                    self.kontest.loadEventCalendar(allEvents: allEvents ?? [])
                }
            })
        }
    }
}
#endif
