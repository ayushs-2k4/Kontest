//
//  NetworkMonitor.swift
//  Kontest
//
//  Created by Ayush Singhal on 13/09/23.
//

import Foundation
import Network
import OSLog

extension NWInterface.InterfaceType: CaseIterable {
    public static var allCases: [NWInterface.InterfaceType] = [.other, .wifi, .cellular, .loopback, .wiredEthernet]
}

extension NWPath.Status: CaseIterable {
    public static var allCases: [NWPath.Status] = [.satisfied, .unsatisfied, .requiresConnection]
}

@Observable
class NetworkMonitor {
    private let logger = Logger(subsystem: "com.ayushsinghal.Kontest", category: "NetworkMonitor")
    static let shared = NetworkMonitor()
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")

    var currentInterface: NWInterface.InterfaceType = .other
    var currentStatus: NWPath.Status = .unsatisfied

    private init() {
        monitor = NWPathMonitor()
    }

    func start() {
        monitor.start(queue: queue)

        let p = monitor.currentPath.status
        logger.log("p: \("\(p)")")
        currentStatus = monitor.currentPath.status

        monitor.pathUpdateHandler = { [weak self] path in

            guard let interface = NWInterface.InterfaceType.allCases.filter({ path.usesInterfaceType($0) }).first else { return }

            self?.currentInterface = interface

            self?.currentStatus = path.status

            self?.logger.info("Status: \("\(path.status)")")
            self?.logger.info("Interface: \("\(interface)")")
        }
    }

    func startFromWidget() async {
        monitor.start(queue: queue)

        try? await Task.sleep(nanoseconds: 2*100000000)

        let p = monitor.currentPath.status
        logger.log("p: \("\(p)")")
        currentStatus = monitor.currentPath.status

        monitor.pathUpdateHandler = { [weak self] path in

            guard let interface = NWInterface.InterfaceType.allCases.filter({ path.usesInterfaceType($0) }).first else { return }

            self?.currentInterface = interface

            self?.currentStatus = path.status

            self?.logger.info("Status: \("\(path.status)")")
            self?.logger.info("Interface: \("\(interface)")")
        }
    }

    func stop() {
        monitor.cancel()
    }
}
