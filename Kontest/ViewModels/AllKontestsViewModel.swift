//
//  AllKontestsViewModel.swift
//  Kontest
//
//  Created by Ayush Singhal on 12/08/23.
//

import Combine
import Foundation
import OSLog

@Observable
class AllKontestsViewModel {
    private let logger = Logger(subsystem: "com.ayushsinghal.Kontest", category: "AllKontestsViewModel")

    let repository: KontestFetcher
    let notificationsViewModel: NotificationsViewModelProtocol
    let filterWebsitesViewModel: FilterWebsitesViewModelProtocol

    private var timer: AnyCancellable?

    var errorWrapper: ErrorWrapper?

    private(set) var allKontests: [KontestModel] = []
    private(set) var toShowKontests: [KontestModel] = []
    private(set) var backupKontests: [KontestModel] = []

    private(set) var ongoingKontests: [KontestModel] = []
    private(set) var laterTodayKontests: [KontestModel] = []
    private(set) var tomorrowKontests: [KontestModel] = []
    private(set) var laterKontests: [KontestModel] = []

    private var nextDateToRefresh: Date?

    private var shouldFetchAllEventsFromCalendar: Bool

    var searchText: String = "" {
        didSet {
            filterKontestsUsingSearchText()
        }
    }

    var isLoading = false

    init(notificationsViewModel: NotificationsViewModelProtocol, filterWebsitesViewModel: FilterWebsitesViewModelProtocol, repository: KontestFetcher) {
        self.repository = repository
        self.notificationsViewModel = notificationsViewModel
        self.filterWebsitesViewModel = filterWebsitesViewModel
        shouldFetchAllEventsFromCalendar = UserDefaults(suiteName: Constants.userDefaultsGroupID)!.bool(forKey: "shouldFetchAllEventsFromCalendar")
        setDefaultValuesForFilterWebsiteKeysToTrue()
        addAllowedWebsites()
        fetchAllKontests()

        #if os(macOS)
        do {
            try addCalendarObserver()
        } catch {
            logger.info("Can not add observer to Calendar with error: \(error)")
        }
        #endif
    }

    func fetchAllKontests() {
        isLoading = true
        Task {
            let allKontests = await getAllKontests()
            let sortedKontests = sortAllKontests(allKontests: allKontests)

            await MainActor.run {
                self.allKontests = sortedKontests
            }

            checkNotificationAuthorization()
            filterKontests()

            // Doing this here (after splitting kontests into categories initially)
            nextDateToRefresh = CalendarUtility.getNextDateToRefresh(
                ongoingKontests: ongoingKontests,
                laterTodayKontests: laterTodayKontests,
                tomorrowKontests: tomorrowKontests,
                laterKontests: laterKontests
            )

            isLoading = false
            removeReminderStatusFromUserDefaultsOfKontestsWhichAreEnded()

            self.timer = Timer.publish(every: 1, on: .main, in: .default)
                .autoconnect()
                .sink { [weak self] timer in
                    guard let self else { return }

                    let timeInterval = Double(timer.timeIntervalSince1970)
                    let currentDate = Date(timeIntervalSince1970: timeInterval)

                    if let nextDateToRefresh {
                        let timeInterval = currentDate.timeIntervalSince(nextDateToRefresh)
                        logger.info("nextDateToRefresh: \(nextDateToRefresh.formatted())\ntimeInterval: \(timeInterval)")

                        if timeInterval >= -5, timeInterval <= 5 {
                            if self.searchText.isEmpty {
                                self.splitKontestsIntoDifferentCategories()
                            }
                        } else if timeInterval > 5, timeInterval <= 10 {
                            logger.log("Getting nextDateToRefresh")
                            self.nextDateToRefresh = CalendarUtility.getNextDateToRefresh(
                                ongoingKontests: ongoingKontests,
                                laterTodayKontests: laterTodayKontests,
                                tomorrowKontests: tomorrowKontests,
                                laterKontests: laterKontests
                            )
                        }
                    } else {
                        if self.searchText.isEmpty {
                            self.splitKontestsIntoDifferentCategories()
                        }
                    }
                }
        }
    }

    private func getAllKontests() async -> [KontestModel] {
        do {
            let fetchedKontests = try await repository.getAllKontests()

            shouldFetchAllEventsFromCalendar = CalendarUtility.getAuthorizationStatus() == .fullAccess

            let allEvents = shouldFetchAllEventsFromCalendar ? try await CalendarUtility.getAllEvents() : []

            let allKontestModels = fetchedKontests
                .map { dto in
                    let kontest = KontestModel.from(dto: dto)
                    // Load Reminder status
                    kontest.loadReminderStatus()

                    // Load Calendar status
                    kontest.loadCalendarStatus(allEvents: allEvents ?? [])
                    kontest.loadCalendarEventDate(allEvents: allEvents ?? [])

                    return kontest
                }
                .filter { kontest in
                    let kontestDuration = CalendarUtility.getFormattedDuration(fromSeconds: kontest.duration) ?? ""
                    let kontestEndDate = CalendarUtility.getDate(date: kontest.end_time)
                    let isKontestEnded = CalendarUtility.isKontestOfPast(kontestEndDate: kontestEndDate ?? Date())

                    return !kontestDuration.isEmpty && !isKontestEnded
                }
            
            return allKontestModels
        } catch {
            logger.error("error in fetching all Kontests: \(error)")
            return []
        }
    }

    private func sortAllKontests(allKontests: [KontestModel]) -> [KontestModel] {
        allKontests.sorted { CalendarUtility.getDate(date: $0.start_time) ?? Date() < CalendarUtility.getDate(date: $1.start_time) ?? Date() }
    }

    private func filterKontestsUsingSearchText() {
        let filteredKontests = backupKontests
            .filter { kontest in
                kontest.name.localizedCaseInsensitiveContains(searchText) || kontest.site.localizedCaseInsensitiveContains(searchText) || kontest.url.localizedCaseInsensitiveContains(searchText)
            }

        // Update the filtered kontests
        toShowKontests = searchText.isEmpty ? backupKontests : filteredKontests

        splitKontestsIntoDifferentCategories()
    }

    private func removeReminderStatusFromUserDefaultsOfKontestsWhichAreEnded() {
        for kontest in toShowKontests {
            if isKontestEnded(kontestEndDate: kontest.end_time) {
                kontest.removeReminderStatusFromUserDefaults()
                logger.info("kontest with id: \(kontest.id)'s notification is deleted as kontest is ended.")
            }
        }
    }

    private func isKontestEnded(kontestEndDate: String) -> Bool {
        let currentDate = Date()
        if let formattedKontestEndDate = CalendarUtility.getDate(date: kontestEndDate) {
            return formattedKontestEndDate < currentDate
        }

        return true
    }

    func filterKontests() {
        toShowKontests = allKontests.filter {
            let isKontestWebsiteInAllowedWebsites = allowedWebsites.contains($0.site)

//            return isKontestWebsiteInAllowedWebsites
            return true
        }
        backupKontests = toShowKontests
        splitKontestsIntoDifferentCategories()
    }

    private func splitKontestsIntoDifferentCategories() {
        print("YEs")
        let today = Date()

        toShowKontests = toShowKontests.filter {
            let kontestEndDate = CalendarUtility.getDate(date: $0.end_time)
            let isKontestEnded = CalendarUtility.isKontestOfPast(kontestEndDate: kontestEndDate ?? Date())

            return !isKontestEnded
        }

        ongoingKontests = toShowKontests.filter { CalendarUtility.isKontestRunning(kontestStartDate: CalendarUtility.getDate(date: $0.start_time) ?? today, kontestEndDate: CalendarUtility.getDate(date: $0.end_time) ?? today) }

        ongoingKontests = ongoingKontests.sorted { kontestModel1, kontestModel2 in
            CalendarUtility.getDate(date: kontestModel1.end_time) ?? Date() < CalendarUtility.getDate(date: kontestModel2.end_time) ?? Date()
        }

        laterTodayKontests = toShowKontests.filter { CalendarUtility.isKontestLaterToday(kontestStartDate: CalendarUtility.getDate(date: $0.start_time) ?? Date()) }

        tomorrowKontests = toShowKontests.filter { CalendarUtility.isKontestTomorrow(kontestStartDate: CalendarUtility.getDate(date: $0.start_time) ?? Date()) }

        laterKontests = toShowKontests.filter { CalendarUtility.isKontestLater(kontestStartDate: CalendarUtility.getDate(date: $0.start_time) ?? Date()) }
    }

    private var allowedWebsites: [String] = []

    func addAllowedWebsites() {
        allowedWebsites.removeAll()

        logger.info("Ran addAllowedWebsites()")

        allowedWebsites.append(contentsOf: filterWebsitesViewModel.getAllowedWebsites())
    }

    private func checkNotificationAuthorization() {
        Task {
            let numberOfNotifications = notificationsViewModel.pendingNotifications.count
            if numberOfNotifications > 0 {
                let notificationsAuthorizationLevel = await LocalNotificationManager.instance.getNotificationsAuthorizationLevel()

                if notificationsAuthorizationLevel.authorizationStatus == .denied {
                    logger.info("notificationsAuthorizationLevel.authorizationStatus: \("\(notificationsAuthorizationLevel.authorizationStatus)")")

                    errorWrapper = ErrorWrapper(error: AppError(title: "Permission not Granted", description: "You have set some notifications, but notification permission is not granted"), guidance: "Please provide Notification Permission in order to get notifications")

                    logger.info("errorWrapper: \("\(String(describing: errorWrapper))")")
                }
            }
        }
    }

    #if os(macOS)
    func addCalendarObserver() throws {
        if CalendarUtility.getAuthorizationStatus() == .fullAccess {
            CalendarUtility.addCalendarObserver { [weak self] _ in
                guard let self else { return }
                print("Yes")

                Task {
                    let allEvents = self.shouldFetchAllEventsFromCalendar ? try await CalendarUtility.getAllEvents() : []

                    for kontest in self.ongoingKontests {
                        kontest.loadCalendarStatus(allEvents: allEvents ?? [])
                        kontest.loadCalendarEventDate(allEvents: allEvents ?? [])
                    }

                    for kontest in self.laterTodayKontests {
                        kontest.loadCalendarStatus(allEvents: allEvents ?? [])
                        kontest.loadCalendarEventDate(allEvents: allEvents ?? [])
                    }

                    for kontest in self.tomorrowKontests {
                        kontest.loadCalendarStatus(allEvents: allEvents ?? [])
                        kontest.loadCalendarEventDate(allEvents: allEvents ?? [])
                    }

                    for kontest in self.laterKontests {
                        kontest.loadCalendarStatus(allEvents: allEvents ?? [])
                        kontest.loadCalendarEventDate(allEvents: allEvents ?? [])
                    }
                }
            }
        }
    }
    #endif
}
