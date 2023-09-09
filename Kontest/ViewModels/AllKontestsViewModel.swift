//
//  AllKontestsViewModel.swift
//  Kontest
//
//  Created by Ayush Singhal on 12/08/23.
//

import Combine
import Foundation

@Observable
class AllKontestsViewModel {
    let repository = KontestRepository()

    static let instance = AllKontestsViewModel()

    private var timer: AnyCancellable?

    private(set) var allKontests: [KontestModel] = []
    private(set) var ongoingKontests: [KontestModel] = []
    private(set) var laterTodayKontests: [KontestModel] = []
    private(set) var tomorrowKontests: [KontestModel] = []
    private(set) var laterKontests: [KontestModel] = []

    var searchText: String = "" {
        didSet {
            updateFilteredKontests()
        }
    }

    var isLoading = false

    private(set) var backupKontests: [KontestModel] = []

    private init() {
        setDefaultValuesForFilterWebsiteKeysToTrue()
        addAllowedWebsites()
        fetchAllKontests()
    }

    func fetchAllKontests() {
        isLoading = true
        filterKontests()
        Task {
            await getAllKontests()
            backupKontests = allKontests
            isLoading = false
            removeReminderStatusFromUserDefaultsOfKontestsWhichAreEnded()

            self.timer = Timer.publish(every: 1, on: .main, in: .default)
                .autoconnect()
                .sink { [weak self] _ in
                    self?.filterKontests()
                }
        }
    }

    private func getAllKontests() async {
        do {
            let fetchedKontests = try await repository.getAllKontests()

            await MainActor.run {
                self.allKontests = fetchedKontests
                    .map { dto in
                        let kontest = KontestModel.from(dto: dto)
                        // Load Reminder status
                        kontest.loadReminderStatus()
                        return kontest
                    }
                    .filter { kontest in
                        let kontestDuration = CalendarUtility.getFormattedDuration(fromSeconds: kontest.duration) ?? ""
                        let kontestEndDate = CalendarUtility.getDate(date: kontest.end_time)
                        let isKontestEnded = CalendarUtility.isKontestOfPast(kontestEndDate: kontestEndDate ?? Date())

                        return !kontestDuration.isEmpty && !isKontestEnded
                    }
            }
        } catch {
            print("error in fetching all Kontests: \(error)")
        }
    }

    private func updateFilteredKontests() {
        let filteredKontests = backupKontests
            .filter { kontest in
                kontest.name.localizedCaseInsensitiveContains(searchText) || kontest.site.localizedCaseInsensitiveContains(searchText) || kontest.url.localizedCaseInsensitiveContains(searchText)
            }

        // Update the filtered kontests
        allKontests = searchText.isEmpty ? backupKontests : filteredKontests
    }

    private func removeReminderStatusFromUserDefaultsOfKontestsWhichAreEnded() {
        for kontest in allKontests {
            if isKontestEnded(kontestEndDate: kontest.end_time) {
                kontest.removeReminderStatusFromUserDefaults()
                print("kontest with id: \(kontest.id)'s notification is deleted as kontest is ended.")
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
        let today = Date()
        let tomorrow = CalendarUtility.getTomorrow()
        let dayAfterTomorrow = CalendarUtility.getDayAfterTomorrow()
        allKontests = backupKontests.filter {
            let isKontestWebsiteInAllowedWebsites = allowedWebsites.contains($0.site)

            return isKontestWebsiteInAllowedWebsites
        }

        ongoingKontests = allKontests.filter { CalendarUtility.isKontestRunning(kontestStartDate: CalendarUtility.getDate(date: $0.start_time) ?? today, kontestEndDate: CalendarUtility.getDate(date: $0.end_time) ?? today) }

        laterTodayKontests = allKontests.filter {
            CalendarUtility.getDate(date: $0.start_time) ?? today < tomorrow && !(ongoingKontests.contains($0))
        }

        tomorrowKontests = allKontests.filter { (CalendarUtility.getDate(date: $0.start_time) ?? today >= tomorrow) && (CalendarUtility.getDate(date: $0.start_time) ?? today < dayAfterTomorrow) }

        laterKontests = allKontests.filter {
            CalendarUtility.getDate(date: $0.start_time) ?? today >= dayAfterTomorrow
        }
    }

    private var allowedWebsites: [String] = []

     func addAllowedWebsites() {
        allowedWebsites.removeAll()
        
        print("Ran addAllowedWebsites()")
        
        if UserDefaults.standard.bool(forKey: FilterWebsiteKey.codeForcesKey.rawValue) {
            allowedWebsites.append("CodeForces")
        }

        if UserDefaults.standard.bool(forKey: FilterWebsiteKey.atCoderKey.rawValue) {
            allowedWebsites.append("AtCoder")
        }

        if UserDefaults.standard.bool(forKey: FilterWebsiteKey.cSAcademyKey.rawValue) {
            allowedWebsites.append("CS Academy")
        }

        if UserDefaults.standard.bool(forKey: FilterWebsiteKey.codeChefKey.rawValue) {
            allowedWebsites.append("CodeChef")
        }

        if UserDefaults.standard.bool(forKey: FilterWebsiteKey.hackerRankKey.rawValue) {
            allowedWebsites.append("HackerRank")
        }

        if UserDefaults.standard.bool(forKey: FilterWebsiteKey.hackerEarthKey.rawValue) {
            allowedWebsites.append("HackerEarth")
        }

        if UserDefaults.standard.bool(forKey: FilterWebsiteKey.leetCodeKey.rawValue) {
            allowedWebsites.append("LeetCode")
        }

        if UserDefaults.standard.bool(forKey: FilterWebsiteKey.tophKey.rawValue) {
            allowedWebsites.append("Toph")
        }
    }
}
