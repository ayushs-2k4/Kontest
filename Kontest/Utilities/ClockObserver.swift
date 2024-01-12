//
//  ClockObserver.swift
//  Kontest
//
//  Created by Ayush Singhal on 1/12/24.
//

import Foundation

class ClockObserver: ObservableObject {
    @Published var clockDidChange = false

    init() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSSystemClockDidChange, object: nil, queue: .main) { _ in
            self.clockDidChange.toggle()
        }
    }
}
