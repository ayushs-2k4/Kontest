//
//  KontestDetailViewModel.swift
//  Kontest
//
//  Created by Ayush Singhal on 06/09/23.
//

import Combine
import SwiftUI

@Observable
class KontestDetailViewModel {
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
    }

    private func updateKontestStatus() {
        print("Running ")
        let kontestStartDate = CalendarUtility.getDate(date: kontest.start_time)
        let kontestEndDate = CalendarUtility.getDate(date: kontest.end_time)
        isKontestRunning = CalendarUtility.isKontestRunning(kontestStartDate: kontestStartDate ?? Date(), kontestEndDate: kontestEndDate ?? Date())

        let isKontestOfFuture = CalendarUtility.isKontestOfFuture(kontestStartDate: kontestStartDate ?? Date())
        let isKontestStartingTimeLessThanADay = !(CalendarUtility.isRemainingTimeGreaterThanGivenTime(date: kontestStartDate, minutes: 0, hours: 0, days: 1))
        isKontestOfFutureAndStartingInLessThan24Hours = isKontestOfFuture && isKontestStartingTimeLessThanADay
    }
}
