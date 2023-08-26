//
//  FontUtility.swift
//  Kontest
//
//  Created by Ayush Singhal on 13/08/23.
//

import Foundation
import SwiftUI

class FontUtility {
    static func getLogoSize() -> CGFloat {
        #if os(iOS)
        return 25
        #else
        return 40
        #endif
    }

    static func getSiteFontSize() -> Font {
        #if os(iOS)
        return Font.title3
        #else
        return Font.title
        #endif
    }

    static func getNameFontSize() -> Font {
        #if os(iOS)
        return .caption2
        #else
        return .body
        #endif
    }

    static func getTimeFontSize() -> Font {
        #if os(iOS)
        return Font.caption
        #else
        return Font.title2
        #endif
    }

    static func getDateFontSize() -> Font {
        #if os(iOS)
        return .caption2
        #else
        return .body
        #endif
    }
    
    static func getRemainingTimeFontSize() -> Font {
        #if os(iOS)
        return .caption2
        #else
        return .body
        #endif
    }
}
