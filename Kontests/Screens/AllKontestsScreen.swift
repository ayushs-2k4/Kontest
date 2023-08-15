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

    var body: some View {
        NavigationStack {
            ZStack {
                if allKontestsViewModel.isLoading {
                    ProgressView()
                } else if allKontestsViewModel.backupKontests.isEmpty {
                    NoKontestsScreen()
                } else {
                    List {
                        let today = Date()
                        let tomorrow = CalendarUtility.getTomorrow()
                        let dayAfterTomorrow = CalendarUtility.getDayAfterTomorrow()

                        let ongoingKontests = allKontestsViewModel.allKontests.filter { CalendarUtility.isKontestRunning(kontestStartDate: CalendarUtility.getDate(date: $0.start_time) ?? Date(), kontestEndDate: CalendarUtility.getDate(date: $0.end_time) ?? Date()) }

                        let laterTodayKontests = allKontestsViewModel.allKontests.filter { (CalendarUtility.getDate(date: $0.start_time) ?? Date() < tomorrow) && !(ongoingKontests.contains($0)) }

                        let tomorrowKontests = allKontestsViewModel.allKontests.filter { (CalendarUtility.getDate(date: $0.start_time) ?? Date() >= tomorrow) && (CalendarUtility.getDate(date: $0.start_time) ?? Date() < dayAfterTomorrow) }

                        let laterKontests = allKontestsViewModel.allKontests.filter { CalendarUtility.getDate(date: $0.start_time) ?? Date() >= dayAfterTomorrow }

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
                KontestDetailsView(kontest: kontest)
            }
        }
    }

    func createSection(title: String, kontests: [KontestModel]) -> some View {
        Section {
            ForEach(kontests) { kontest in
                #if os(macOS)
                    Link(destination: URL(string: kontest.url)!, label: {
                        SingleKontestView(kontest: kontest, allKontestsViewModel: allKontestsViewModel)
                    })
                #else
                    NavigationLink(value: kontest) {
                        SingleKontestView(kontest: kontest, allKontestsViewModel: allKontestsViewModel)
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
