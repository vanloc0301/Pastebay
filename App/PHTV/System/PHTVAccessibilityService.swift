//
//  PHTVAccessibilityService.swift
//  Pastebay
//

import AppKit
@preconcurrency import ApplicationServices
import Foundation

@objcMembers
final class PastebayAccessibilityService: NSObject {
    @discardableResult
    class func requestAccessibilityPrompt() -> Bool {
        let promptKey = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String
        return AXIsProcessTrustedWithOptions([promptKey: true] as CFDictionary)
    }

    class func openAccessibilityPreferences() {
        _ = requestAccessibilityPrompt()
        for urlString in accessibilitySettingsURLs {
            guard let url = URL(string: urlString), NSWorkspace.shared.open(url) else { continue }
            return
        }
    }

    private static let accessibilitySettingsURLs = [
        "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility",
        "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension?Privacy_Accessibility"
    ]
}
