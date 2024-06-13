//
//  KontestApp.swift
//  Kontest
//
//  Created by Ayush Singhal on 12/08/23.
//

import Firebase
import OSLog
import SwiftUI

@main
struct KontestApp: App {
    private let logger = Logger(subsystem: "com.ayushsinghal.Kontest", category: "KontestApp")

    init() {
        networkMonitor.start(afterSeconds: 0.5)
    }

    @State private var allKontestsViewModel = Dependencies.instance.allKontestsViewModel

    @State private var router = Router.instance
    @State private var errorState = ErrorState()
    @State private var panelSelection: Panel? = .AllKontestScreen

    let networkMonitor = NetworkMonitor.shared

    @State private var isAlertDisplayed: Bool = false
    @State private var errorWrapper: ErrorWrapper = .init(error: AppError(title: "", description: ""), guidance: "")

    var body: some Scene {
        WindowGroup {
            if let defaults = UserDefaults(suiteName: Constants.userDefaultsGroupID) {
                Group {
                    if #available(macOS 15.0, iOS 18.0, *) {
                        TabView(selection: $panelSelection) {
                            Tab("All Kontests", systemImage: "list.bullet", value: .AllKontestScreen) {
                                AllKontestsScreen()
                            }

                            Tab("LeetCode", systemImage: "leetcode", value: .LeetCodeGraphView) {
                                LeetcodeGraphView()
                            }

                            Tab("CodeForces", systemImage: "codeforces", value: .CodeForcesGraphView) {
                                CodeForcesGraphView()
                            }

                            Tab("CodeChef", systemImage: "codechef", value: .CodeChefGraphView) {
                                CodeChefGraphView()
                            }
                        }
                    } else {
                        ContentView(panelSelection: $panelSelection)
                    }
                }
                .environment(allKontestsViewModel)
                .environment(router)
                .environment(networkMonitor)
                .environment(errorState)
                .onChange(of: errorState.errorWrapper) {
                    if let errorWrapper = errorState.errorWrapper {
                        self.errorWrapper = errorWrapper
                        self.isAlertDisplayed = true
                    }
                }
#if os(iOS)
//                    .sheet(item: $errorState.errorWrapper) { errorWrapper in
//                        ErrorView(errorWrapper: errorWrapper)
//                            .apply {
//                                if #available(iOS 18.0, *) {
//                                    $0.presentationSizing(.fitted)
//                                } else {
//                                    $0
//                                }
//                            }
//                    }
                .alert(errorState.errorWrapper?.error is AppError ? (errorWrapper.error as! AppError).title : "Error has occurred", isPresented: $isAlertDisplayed, actions: {
                    Button("Dismiss") {}

                    if errorWrapper.error is AppError {
                        let appError = errorWrapper.error as! AppError

                        if let action = appError.action {
                            Button(appError.actionLabel) {
                                action()
                            }
                        }
                    }
                }, message: {
                    Text(errorWrapper.error.localizedDescription)

                    Text(errorWrapper.guidance)
                        .font(.caption)
                })

#endif
#if os(macOS)
                .onAppear(perform: {
    disallowTabbingMode()
})
.frame(minWidth: 900, idealWidth: 1100, minHeight: 500, idealHeight: 600)
#endif
.defaultAppStorage(defaults)
            } else {
                Text("Failed to load user defaults")
            }
        }
        .commands {
            MyMenu(router: $router, panelSelection: $panelSelection)
        }

#if os(macOS)
        if #available(macOS 15.0, *) {
            openAlertWindow(errorWrapper: self.errorWrapper, isPresented: $isAlertDisplayed)
        }
#endif
    }
}

#if os(macOS)
@available(macOS 15.0, *)
func openAlertWindow(errorWrapper: ErrorWrapper, isPresented: Binding<Bool>) -> some Scene {
    AlertScene(errorWrapper.error is AppError ? (errorWrapper.error as! AppError).title : "Error has occurred", isPresented: isPresented, actions: {
        Button("Dismiss") {}

        if errorWrapper.error is AppError {
            let appError = errorWrapper.error as! AppError

            if let action = appError.action {
                Button(appError.actionLabel) {
                    action()
                }
            }
        }
    }, message: {
        Text(errorWrapper.error.localizedDescription)

        Text(errorWrapper.guidance)
            .font(.caption)
    })
}
#endif

#if os(macOS)
@MainActor
fileprivate func disallowTabbingMode() {
    NSWindow.allowsAutomaticWindowTabbing = false
}
#endif

extension View {
    func apply<V: View>(@ViewBuilder _ block: (Self) -> V) -> V { block(self) }
}
