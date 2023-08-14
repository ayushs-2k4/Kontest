//
//  ClipboardUtility.swift
//  Kontests
//
//  Created by Ayush Singhal on 13/08/23.
//

#if os(macOS)
    import AppKit
#elseif os(iOS)
    import UIKit
#endif

enum ClipboardUtility {
    static func copyToClipBoard(_ text: String) {
        #if os(macOS)
            let clipboard = NSPasteboard.general
            clipboard.clearContents()
            clipboard.setString(text, forType: .string)
        #else
            let clipboard = UIPasteboard.general
            clipboard.string = text
        #endif
    }
}
