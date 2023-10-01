//
//  DeviceType.swift
//  Kontest
//
//  Created by Ayush Singhal on 02/10/23.
//

import Foundation
#if os(iOS)
import UIKit
#endif

enum DeviceType {
    case macOS
    case iOS
    case iPadOS
}

func getDeviceType() -> DeviceType {
    #if os(macOS)
    return DeviceType.macOS
    #elseif os(iOS)
    if UIDevice.current.userInterfaceIdiom == .phone {
        return DeviceType.iOS
    } else {
        return DeviceType.iPadOS
    }
    #endif
}
