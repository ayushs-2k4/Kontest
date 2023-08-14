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
                }
                else if allKontestsViewModel.allKontests.isEmpty {
                    NoKontestsScreen()
                }
                else {
                    List {
                        ForEach(allKontestsViewModel.allKontests) { kontest in

                            #if os(macOS)
                            Link(destination: URL(string: kontest.url)!, label: {
                                SingleKontentView(kontest: kontest, allKontestsViewModel: allKontestsViewModel)
                            })
                            #else
                            NavigationLink(value: kontest) {
                                SingleKontentView(kontest: kontest, allKontestsViewModel: allKontestsViewModel)
                            }
                            #endif
                        }
                    }
//                    .searchable(text: Bindable(allKontestsViewModel).searchText)
                }
            }
            .navigationTitle("Kontests")
            .onAppear {
                NotificationManager.instance.setBadgeCountTo0()
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
                            NotificationManager.instance.scheduleIntervalNotification()
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
}

#Preview {
    AllKontestsScreen()
        .environment(AllKontestsViewModel())
}
