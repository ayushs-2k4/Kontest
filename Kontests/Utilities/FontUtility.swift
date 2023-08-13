//
//  FontUtility.swift
//  Kontests
//
//  Created by Ayush Singhal on 13/08/23.
//

import Foundation

class FontUtility {
    static func getLogoSize() -> CGFloat {
        #if os(iOS)
            return 25
        #else
            return 40
        #endif
    }

    static func getTimeFontSize() -> CGFloat {
        #if os(iOS)
            return 15
        #else
            return 25
        #endif
    }

    static func getDateFontSize() -> CGFloat {
        #if os(iOS)
            return 12
        #else
            return 17
        #endif
    }
}
