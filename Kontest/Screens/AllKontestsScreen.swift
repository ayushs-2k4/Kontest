//
//  AllKontestsScreen.swift
//  Kontest
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

    @Environment(Router.self) private var router

    var body: some View {
        NavigationStack(path: Bindable(router).path) {
            ZStack {
                if allKontestsViewModel.isLoading {
                    ProgressView()
                } else if allKontestsViewModel.backupKontests.isEmpty {
                    NoKontestsScreen()
                } else {
                    VStack {
                        List {
                            RatingsView(codeForcesUsername: settingsViewModel.codeForcesUsername, leetCodeUsername: settingsViewModel.leetcodeUsername)

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
                        .listStyle(.plain)
                    }
                    #if os(macOS)
                    .searchable(text: Bindable(allKontestsViewModel).searchText)
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
                            router.path.append(Screens.PendingNotificationsScreen)
                        } label: {
                            Text("All Pending Notifications")
                        }
                    }

                    ToolbarItem(placement: .automatic) { // change the placement here!
                        Button {
                            allKontestsViewModel.printAllPendingNotifications()
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
                            router.path.append(Screens.SettingsScreen)
                        } label: {
                            Image(systemName: "gear")
                        }
                        .keyboardShortcut(",")
                    }

                    ToolbarItem(placement: .automatic) {
                        AllNotificationMenu()
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

                case .PendingNotificationsScreen:
                    PendingNotificationsScreen()
                }
            }
        }
        #if !os(macOS)
        .searchable(text: Bindable(allKontestsViewModel).searchText)
        #endif
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
        .environment(Router.instance)
}
