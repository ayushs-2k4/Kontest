//
//  AllKontestsScreen.swift
//  Kontests
//
//  Created by Ayush Singhal on 12/08/23.
//

import SwiftUI

struct AllKontestsScreen: View {
    @Environment(AllKontestsViewModel.self) private var allKontestsViewModel
    @State var showRemoveAllNotificationsAlert = false
    @State var showNotificationForAllKontestsAlert = false
    let isInDevelopmentMode = false

    let settingsViewModel = SettingsViewModel.instance

    @State var navigationPath: NavigationPath = .init()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                if allKontestsViewModel.isLoading {
                    ProgressView()
                } else if allKontestsViewModel.backupKontests.isEmpty {
                    NoKontestsScreen()
                } else {
                    VStack {
                        RatingsView(codeForcesUsername: settingsViewModel.codeForcesUsername, leetCodeUsername: settingsViewModel.leetcodeUsername)

                        List {
                            let today = Date()
                            let tomorrow = CalendarUtility.getTomorrow()
                            let dayAfterTomorrow = CalendarUtility.getDayAfterTomorrow()

                            let ongoingKontests = allKontestsViewModel.allKontests.filter { CalendarUtility.isKontestRunning(kontestStartDate: CalendarUtility.getDate(date: $0.start_time) ?? today, kontestEndDate: CalendarUtility.getDate(date: $0.end_time) ?? today) }

                            let laterTodayKontests = allKontestsViewModel.allKontests.filter { (CalendarUtility.getDate(date: $0.start_time) ?? today < tomorrow) && !(ongoingKontests.contains($0)) }

                            let tomorrowKontests = allKontestsViewModel.allKontests.filter { (CalendarUtility.getDate(date: $0.start_time) ?? today >= tomorrow) && (CalendarUtility.getDate(date: $0.start_time) ?? today < dayAfterTomorrow) }

                            let laterKontests = allKontestsViewModel.allKontests.filter { CalendarUtility.getDate(date: $0.start_time) ?? today >= dayAfterTomorrow }

                            if ongoingKontests.count > 0 {
                                createSection(title: "Live Now", kontests: ongoingKontests)
                            }

                            if laterTodayKontests.count > 0 {
                                createSection(title: "Later Today", kontests: laterTodayKontests)
                            }

                            if tomorrowKontests.count > 0 {
                                createSection(title: "Tomorrow", kontests: tomorrowKontests)
                            }

                            if laterKontests.count > 0 {
                                createSection(title: "Upcoming", kontests: laterKontests)
                            }
                        }
                    }
                    .searchable(text: Bindable(allKontestsViewModel).searchText)
                }
            }
            .navigationTitle("Kontests")
            .onAppear {
                LocalNotificationManager.instance.setBadgeCountTo0()
            }
            .toolbar {
                if isInDevelopmentMode {
                    ToolbarItem(placement: .automatic) { // change the placement here!
                        Button {
                            allKontestsViewModel.getAllPendingNotifications()
                        } label: {
                            Text("Print all notifs")
                        }
                    }

                    ToolbarItem(placement: .automatic) { // change the placement here!
                        Button {
                            LocalNotificationManager.instance.scheduleIntervalNotification()
                        } label: {
                            Text("Schedule 5 seconds Notification")
                        }
                    }
                }

                if !allKontestsViewModel.allKontests.isEmpty {
                    ToolbarItem(placement: .automatic) {
                        Button {
                            navigationPath.append(Screens.SettingsScreen)
                        } label: {
                            Image(systemName: "gear")
                        }
                    }

                    ToolbarItem(placement: .automatic) { // change the placement here!
                        Button {
                            showNotificationForAllKontestsAlert = true
                            allKontestsViewModel.setNotificationForAllKontests()
                        } label: {
                            Image(systemName: "bell.fill")
                        }
                        .help("Set Notification for all following kontests") // Tooltip text
                        .alert("Notification for all Kontests set", isPresented: $showNotificationForAllKontestsAlert, actions: {})
                    }

                    ToolbarItem(placement: .automatic) { // change the placement here!
                        Button {
                            showRemoveAllNotificationsAlert = true
                            allKontestsViewModel.removeAllPendingNotifications()
                        } label: {
                            Image(systemName: "bell.slash")
                        }
                        .help("Remove All Notifications") // Tooltip text
                        .alert("All Notifications Removed", isPresented: $showRemoveAllNotificationsAlert, actions: {})
                    }
                }
            }
            .navigationDestination(for: KontestModel.self) { kontest in
                KontestDetailsScreen(kontest: kontest)
            }
            .navigationDestination(for: Screens.self) { screen in
                switch screen {
                case Screens.SettingsScreen:
                    SettingsScreen()
                }
            }
        }
        .searchable(text: Bindable(allKontestsViewModel).searchText)
    }

    func createSection(title: String, kontests: [KontestModel]) -> some View {
        Section {
            ForEach(kontests) { kontest in
                #if os(macOS)
                    Link(destination: URL(string: kontest.url)!, label: {
                        SingleKontestView(kontest: kontest)
                    })
                #else
                    NavigationLink(value: kontest) {
                        SingleKontestView(kontest: kontest)
                    }
                #endif
            }
        } header: {
            Text(title)
        }
    }
}

#Preview {
    AllKontestsScreen()
        .environment(AllKontestsViewModel())
}
