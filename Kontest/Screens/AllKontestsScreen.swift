//
//  AllKontestsScreen.swift
//  Kontest
//
//  Created by Ayush Singhal on 12/08/23.
//

import SwiftUI
import WidgetKit

struct AllKontestsScreen: View {
    let isInDevelopmentMode = false

    @Environment(AllKontestsViewModel.self) private var allKontestsViewModel
    @Environment(NetworkMonitor.self) private var networkMonitor
    @Environment(\.openURL) var openURL
    @Environment(ErrorState.self) private var errorState
    @Environment(Router.self) private var router

    @State var showRemoveAllNotificationsAlert = false
    @State var showNotificationForAllKontestsAlert = false
    @State private var showAddAllKontestToCalendarAlert = false
    @State private var isNoNotificationIconAnimating = false
    @State private var isAddAllKontestsToCalendarIconAnimating = false
    @State private var isRemoveAllKontestsFromCalendarIconAnimating = false

    @FocusState var isSearchFiedFocused: Bool

    let notificationsViewModel = Dependencies.instance.notificationsViewModel

    let changeUsernameViewModel = Dependencies.instance.changeUsernameViewModel

    let userDefaults = UserDefaults(suiteName: Constants.userDefaultsGroupID)
    @State private var text: String = ""

    var body: some View {
        NavigationStack(path: Bindable(router).path) {
            if networkMonitor.currentStatus == .initialPhase {
                ProgressView()
            } else if networkMonitor.currentStatus == .satisfied {
                ZStack {
                    if allKontestsViewModel.isLoading {
                        ProgressView()
                    } else if allKontestsViewModel.allFetchedKontests.isEmpty { // No Kontests Downloaded
                        List {
                            RatingsView(
                                codeForcesUsername: changeUsernameViewModel.codeForcesUsername,
                                leetCodeUsername: changeUsernameViewModel.leetcodeUsername,
                                codeChefUsername: changeUsernameViewModel.codeChefUsername
                            )
                            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .listRowSeparator(.hidden)

                            HStack {
                                Spacer()
                                NoKontestsDownloadedScreen()
                                Spacer()
                            }
                        }

                    } else { // There are some kontests downloaded
                        TimelineView(.periodic(from: .now, by: 1)) { timelineViewDefaultContext in
                            List {
                                RatingsView(codeForcesUsername: changeUsernameViewModel.codeForcesUsername, leetCodeUsername: changeUsernameViewModel.leetcodeUsername, codeChefUsername: changeUsernameViewModel.codeChefUsername)
                                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                                    .listRowSeparator(.hidden)

                                if allKontestsViewModel.backupKontests.isEmpty { // There are some kontests but they are hidden due to KontestFilters
                                    NoKontestsDueToFiltersScreen()
                                } else {
                                    let ongoingKontests = allKontestsViewModel.ongoingKontests

                                    let laterTodayKontests = allKontestsViewModel.laterTodayKontests

                                    let tomorrowKontests = allKontestsViewModel.tomorrowKontests

                                    let laterKontests = allKontestsViewModel.laterKontests

                                    if allKontestsViewModel.toShowKontests.isEmpty && !allKontestsViewModel.searchText.isEmpty {
                                        ContentUnavailableView.search
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                    } else {
                                        if ongoingKontests.count > 0 {
                                            createSection(title: "Live Now - \(ongoingKontests.count)", kontests: ongoingKontests, timelineViewDefaultContext: timelineViewDefaultContext)
                                        }

                                        if laterTodayKontests.count > 0 {
                                            createSection(title: "Later Today - \(laterTodayKontests.count)", kontests: laterTodayKontests, timelineViewDefaultContext: timelineViewDefaultContext)
                                        }

                                        if tomorrowKontests.count > 0 {
                                            createSection(title: "Tomorrow - \(tomorrowKontests.count)", kontests: tomorrowKontests, timelineViewDefaultContext: timelineViewDefaultContext)
                                        }

                                        if laterKontests.count > 0 {
                                            createSection(title: "Upcoming - \(laterKontests.count)", kontests: laterKontests, timelineViewDefaultContext: timelineViewDefaultContext)
                                        }
                                    }
                                }
                            }
                        }
                        #if os(macOS)
                        .searchable(text: Bindable(allKontestsViewModel).searchText)
                        .apply {
                            if #available(macOS 15.0, *) {
                                $0
                                    .searchFocused($isSearchFiedFocused)
                            } else {
                                $0
                            }
                        }
//                        .background(Button("", action: { self.isSearchFiedFocused = true }).keyboardShortcut("f").hidden())
                        #endif
                    }
                }
                .navigationTitle("Kontest")
                .onAppear {
                    LocalNotificationManager.instance.setBadgeCountTo0()
                }
                .toolbar {
                    if isInDevelopmentMode {
                        ToolbarItem(placement: .automatic) { // change the placement here!
                            Button {
                                router.appendScreen(screen: .PendingNotificationsScreen)
                            } label: {
                                Text("All Pending Notifications")
                            }
                        }

                        ToolbarItem(placement: .automatic) { // change the placement here!
                            Button {
                                notificationsViewModel.printAllPendingNotifications()
                            } label: {
                                Text("Print all notifs")
                            }
                        }

                        ToolbarItem(placement: .automatic) { // change the placement here!
                            let timeInSeconds = 5

                            Button {
                                LocalNotificationManager.instance.scheduleIntervalNotification(id: "This is id for notification with time \(timeInSeconds) seconds", timeIntervalInSeconds: timeInSeconds)
                            } label: {
                                Text("Schedule \(timeInSeconds) seconds Notification")
                            }
                        }

                        ToolbarItem(placement: .automatic) { // change the placement here!
                            let timeInSeconds = 5

                            Button {
                                LocalNotificationManager.instance.removeNotification(withID: "This is id for notification with time \(timeInSeconds) seconds")
                            } label: {
                                Text("Remove 5 seconds Notification")
                            }
                        }

                        ToolbarItem(placement: .automatic) { // change the placement here!
                            Button {
                                WidgetCenter.shared.reloadAllTimelines()
                            } label: {
                                Text("Reload all widgets")
                            }
                        }

                        ToolbarItem(placement: .automatic) { // change the placement here!
                            Button {
                                allKontestsViewModel.errorWrapper = ErrorWrapper(error: AppError(title: "Fake Error Title", description: "Fake Error Description"), guidance: "Fake Error Guidance")
                            } label: {
                                Text("Invoke Error Wrapper")
                            }
                        }
                    }

                    if !allKontestsViewModel.allKontests.isEmpty || !allKontestsViewModel.searchText.isEmpty {
                        ToolbarItem(placement: .automatic) {
                            AllNotificationMenu()
                        }

                        ToolbarItem(placement: .automatic) { // change the placement here!
                            Button {
                                showRemoveAllNotificationsAlert = true

                                var transaction = Transaction()
                                transaction.disablesAnimations = true
                                withTransaction(transaction) {
                                    isNoNotificationIconAnimating = false
                                }
                            } label: {
                                Image(systemName: "bell.slash")
                                    .symbolEffect(.bounce.up.byLayer, value: isNoNotificationIconAnimating)
                            }
                            .help("Remove all Notification") // Tooltip text
                            .alert("Remove all Notification", isPresented: $showRemoveAllNotificationsAlert, actions: {
                                Button("Remove all", role: .destructive) {
                                    notificationsViewModel.removeAllPendingNotifications()
                                    isNoNotificationIconAnimating = true
                                }
                            })
                        }

                        if CalendarUtility.getAuthorizationStatus() == .fullAccess {
                            ToolbarItem(placement: .automatic) { // change the placement here!
                                Button {
                                    showAddAllKontestToCalendarAlert = true

                                    var transaction = Transaction()
                                    transaction.disablesAnimations = true
                                    withTransaction(transaction) {
                                        isAddAllKontestsToCalendarIconAnimating = false
                                    }
                                } label: {
                                    Image(systemName: "calendar.badge.plus")
                                        .symbolEffect(.bounce.up.byLayer, value: isAddAllKontestsToCalendarIconAnimating)
                                }
                                .help("Add all events to Calendar") // Tooltip text
                                .alert("Add all events to your default calendar?", isPresented: $showAddAllKontestToCalendarAlert, actions: {
                                    Button("Add") {
                                        isAddAllKontestsToCalendarIconAnimating = true

                                        Task {
                                            for kontest in allKontestsViewModel.toShowKontests {
                                                let kontestStartDate = CalendarUtility.getDate(date: kontest.start_time) ?? Date()
                                                let kontestEndDate = CalendarUtility.getDate(date: kontest.end_time)
                                                let setDate = kontestStartDate.addingTimeInterval(-15 * 60)

                                                if !kontest.isCalendarEventAdded {
                                                    if try await CalendarUtility.addEvent(
                                                        startDate: kontestStartDate,
                                                        endDate: kontestEndDate ?? Date(),
                                                        title: kontest.name,
                                                        notes: "",
                                                        url: URL(string: kontest.url),
                                                        alarmAbsoluteDate: setDate
                                                    ) {
                                                        kontest.isCalendarEventAdded = true
                                                        kontest.calendarEventDate = setDate
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    Button("Cancel") {}
                                })
                            }

                            ToolbarItem(placement: .automatic) { // change the placement here!
                                Button {
                                    isRemoveAllKontestsFromCalendarIconAnimating = true

                                    var transaction = Transaction()
                                    transaction.disablesAnimations = true
                                    withTransaction(transaction) {
                                        isRemoveAllKontestsFromCalendarIconAnimating = false
                                    }

                                    Task {
                                        for kontest in allKontestsViewModel.toShowKontests {
                                            let kontestStartDate = CalendarUtility.getDate(date: kontest.start_time) ?? Date()
                                            let kontestEndDate = CalendarUtility.getDate(date: kontest.end_time) ?? Date()

                                            if kontest.isCalendarEventAdded {
                                                try await CalendarUtility.removeEvent(
                                                    startDate: kontestStartDate,
                                                    endDate: kontestEndDate,
                                                    title: kontest.name,
                                                    notes: "",
                                                    url: URL(string: kontest.url)
                                                )

                                                kontest.isCalendarEventAdded = false
                                                kontest.calendarEventDate = nil
                                            }
                                        }
                                    }
                                } label: {
                                    Image(systemName: "calendar.badge.minus")
                                        .symbolEffect(.bounce.up.byLayer, value: isRemoveAllKontestsFromCalendarIconAnimating)
                                }
                                .help("Remove all events from Calendar") // Tooltip text
                            }
                        }
                    }

                    ToolbarItem(placement: .automatic) {
                        Button {
                            router.appendScreen(screen: .SettingsScreen)
                        } label: {
                            Image(systemName: "gear")
                        }
                        .help("Settings") // Tooltip text
                    }
                }
                .navigationDestination(for: SelectionState.self) { state in
                    switch state {
                    case .screen(let screen):
                        switch screen {
                        case .AllKontestScreen:
                            AllKontestsScreen()

                        case Screen.SettingsScreen:
                            SettingsScreen()

                        case .PendingNotificationsScreen:
                            PendingNotificationsScreen()

                        case .SettingsScreenType(let settingsScreenType):
                            switch settingsScreenType {
                            case .ChangeUserNamesScreen:
                                ChangeUsernameScreen()

                            case .FilterWebsitesScreen:
                                FilterWebsitesScreen()

                            case .RotatingMapScreen:
                                RandomRotatingMapScreen(navigationTitle: "About Me")

                            case .AuthenticationScreenType(let authenticationScreenType):
                                switch authenticationScreenType {
                                case .SignInScreen:
                                    SignInScreen()

                                case .SignUpScreen:
                                    SignUpScreen()

                                case .AccountInformationScreen:
                                    AccountInformationScreen()
                                }
                            }
                        }

                    case .kontestModel(let kontest):
                        #if os(iOS)
                        KontestDetailsScreen(kontest: kontest)
                        #endif
                    }
                }
            } else {
                NoInternetScreen()
            }
        }
        .onChange(of: networkMonitor.currentStatus) {
            if networkMonitor.currentStatus == .satisfied {
                allKontestsViewModel.fetchAllKontests()

                Dependencies.instance.reloadLeetcodeUsername()
                Dependencies.instance.reloadCodeChefUsername()
                Dependencies.instance.reloadCodeForcesUsername()

                WidgetCenter.shared.reloadAllTimelines()
            }
        }
        .onChange(of: allKontestsViewModel.errorWrapper) { _, newValue in
            if let newValue {
                errorState.errorWrapper = newValue
            }
        }
        #if !os(macOS)
        .searchable(text: Bindable(allKontestsViewModel).searchText)
        #endif
    }

    func createSection(title: String, kontests: [KontestModel], timelineViewDefaultContext: TimelineViewDefaultContext) -> some View {
        Section {
            ForEach(kontests) { kontest in
                #if os(macOS)
                kontestView(kontest: kontest, timelineViewDefaultContext: timelineViewDefaultContext)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        openURL(URL(string: kontest.url)!)
                    }
                #else
                NavigationLink(value: SelectionState.kontestModel(kontest)) {
                    kontestView(kontest: kontest, timelineViewDefaultContext: timelineViewDefaultContext)
                }
                #endif
            }
        } header: {
            Text(title)
        }
    }
}

extension AllKontestsScreen {
    func calendarSwipeButtonAction(kontest: KontestModel) {
        let kontestStartDate = CalendarUtility.getDate(date: kontest.start_time)
        let kontestEndDate = CalendarUtility.getDate(date: kontest.end_time)
        print("Setted")

        if let kontestStartDate {
            if kontest.isCalendarEventAdded {
                Task {
                    do {
                        try await CalendarUtility.removeEvent(startDate: kontestStartDate, endDate: kontestEndDate ?? Date(), title: kontest.name, notes: "", url: URL(string: kontest.url))

                        kontest.isCalendarEventAdded = false
                        kontest.calendarEventDate = nil
                    } catch {
                        errorState.errorWrapper = ErrorWrapper(error: error, guidance: "Check that you have given Kontest the Calendar Permission (Full Access)")
                    }

                    WidgetCenter.shared.reloadAllTimelines()
                }
            } else {
                Task {
                    do {
                        if kontest.isCalendarEventAdded { // If one event was already setted, then remove it and set a new event
                            try await CalendarUtility.removeEvent(startDate: kontestStartDate, endDate: kontestEndDate ?? Date(), title: kontest.name, notes: "", url: URL(string: kontest.url))
                        }

                        if try await CalendarUtility.addEvent(startDate: kontestStartDate, endDate: kontestEndDate ?? Date(), title: kontest.name, notes: "", url: URL(string: kontest.url), alarmAbsoluteDate: kontestStartDate.addingTimeInterval(-15 * 60)) {
                            kontest.isCalendarEventAdded = true
                            kontest.calendarEventDate = kontestStartDate.addingTimeInterval(-15 * 60)
                        }
                    } catch {
                        errorState.errorWrapper = ErrorWrapper(error: error, guidance: "")
                    }

                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
        }
    }
}

extension AllKontestsScreen {
    @ViewBuilder
    func kontestView(kontest: KontestModel, timelineViewDefaultContext: TimelineViewDefaultContext) -> some View {
        let kontestStartDate = CalendarUtility.getDate(date: kontest.start_time)
        let kontestEndDate = CalendarUtility.getDate(date: kontest.end_time)

        SingleKontestView(kontest: kontest, timelineViewDefaultContext: timelineViewDefaultContext)
            .swipeActions(edge: .leading) {
                if let kontestStartDate, let kontestEndDate, !CalendarUtility.isKontestRunning(kontestStartDate: kontestStartDate, kontestEndDate: kontestEndDate) {
                    Button("", systemImage: kontest.isCalendarEventAdded ? "calendar.badge.minus" : "calendar.badge.plus") {
                        calendarSwipeButtonAction(kontest: kontest)
                    }
                    .tint(Color(red: 94/255, green: 92/255, blue: 222/255))
                }
            }
            .swipeActions(edge: .trailing) {
                let numberOfNotificationsWhichCanBeSettedForAKontest = notificationsViewModel.getNumberOfNotificationsWhichCanBeSettedForAKontest(kontest: kontest)

                if numberOfNotificationsWhichCanBeSettedForAKontest > 0 {
                    let numberOfNotificationsWhichAreCurrentlySetted = notificationsViewModel.getNumberOfSettedNotificationForAKontest(kontest: kontest)
                    let image = notificationsViewModel.isSetForAllNotifications(kontest: kontest) ? "bell.fill" : "bell"
                    let title = notificationsViewModel.isSetForAllNotifications(kontest: kontest) ? "Remove all notifications" : "Set all notifications"

                    Button(title, systemImage: image) {
                        if numberOfNotificationsWhichAreCurrentlySetted < numberOfNotificationsWhichCanBeSettedForAKontest {
                            setNotificationForAKontestAtAllTimes(kontest: kontest)
                        } else {
                            notificationsViewModel.removeAllNotificationForAKontest(kontest: kontest)
                        }
                    }
                }
            }
    }

    private func setNotificationForAKontestAtAllTimes(kontest: KontestModel) {
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
}

#Preview {
    let networkMonitor = NetworkMonitor.shared

    return AllKontestsScreen()
        .environment(networkMonitor)
        .environment(Dependencies.instance.allKontestsViewModel)
        .environment(Router.instance)
        .environment(ErrorState())
}
