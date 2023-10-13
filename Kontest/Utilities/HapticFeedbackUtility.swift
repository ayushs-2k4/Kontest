//
//  HapticFeedbackUtility.swift
//  Kontest
//
//  Created by Ayush Singhal on 13/10/23.
//

import Foundation
#if os(macOS)
    import AppKit
#endif

class HapticFeedbackUtility {
    #if os(macOS)
        static func getModelIdentifier() -> String? {
            let service = IOServiceGetMatchingService(kIOMainPortDefault,
                                                      IOServiceMatching("IOPlatformExpertDevice"))
            var modelIdentifier: String?
            if let modelData = IORegistryEntryCreateCFProperty(service, "model" as CFString, kCFAllocatorDefault, 0).takeRetainedValue() as? Data {
                modelIdentifier = String(data: modelData, encoding: .utf8)?.trimmingCharacters(in: .controlCharacters)
            }

            IOObjectRelease(service)
            return modelIdentifier
        }

        static func perf() {
            performHapticFeedback()
        }

        static func performHapticFeedback() {
            let hapticPerformer: NSHapticFeedbackPerformer? = NSHapticFeedbackManager.defaultPerformer

            hapticPerformer?.perform(.alignment, performanceTime: .now)
        }

    #endif
}
