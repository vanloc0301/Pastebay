//
//  Constants.swift
//  Pastebay
//

import AppKit
import Foundation

enum UserDefaultsKey {
    static let enableClipboardHistory = "Pastebay_EnableClipboardHistory"
    static let clipboardHotkeyModifiers = "Pastebay_ClipboardHotkeyModifiers"
    static let clipboardHotkeyKeyCode = "Pastebay_ClipboardHotkeyKeyCode"
    static let clipboardHistoryMaxItems = "Pastebay_ClipboardHistoryMaxItems"
    static let clipboardHistoryData = "Pastebay_ClipboardHistoryData"
}

enum NotificationName {
    static let clipboardHotkeySettingsChanged = Notification.Name("PastebayClipboardHotkeySettingsChanged")
    static let showSettings = Notification.Name("PastebayShowSettings")
    static let applicationWillTerminate = Notification.Name("PastebayApplicationWillTerminate")
}

enum Defaults {
    static let enableClipboardHistory = true
    static let clipboardHotkeyModifiers = NSEvent.ModifierFlags.control.rawValue
    static let clipboardHotkeyKeyCode = KeyCode.vKey
    static let clipboardHistoryMaxItems = 500
}

enum KeyCode {
    static let noKey: UInt16 = 0xFE
    static let keyMask = 0x00FF
    static let escape: UInt16 = 53
    static let vKey: UInt16 = 9
    static let eKey: UInt16 = 14
    static let space: UInt16 = 49
    static let modifierOnlyDisplayName = "Không"

    static let keyNames: [UInt16: String] = [
        0x00: "A", 0x01: "S", 0x02: "D", 0x03: "F", 0x04: "H",
        0x05: "G", 0x06: "Z", 0x07: "X", 0x08: "C", 0x09: "V",
        0x0B: "B", 0x0C: "Q", 0x0D: "W", 0x0E: "E", 0x0F: "R",
        0x10: "Y", 0x11: "T",
        0x12: "1", 0x13: "2", 0x14: "3", 0x15: "4", 0x16: "6",
        0x17: "5", 0x19: "9", 0x1A: "7", 0x1C: "8", 0x1D: "0",
        0x18: "=", 0x1B: "-", 0x1E: "]", 0x21: "[", 0x27: "'",
        0x29: ";", 0x2A: "\\", 0x2B: ",", 0x2C: "/", 0x2F: ".",
        0x31: "Space", 0x32: "`",
        0x1F: "O", 0x20: "U", 0x22: "I", 0x23: "P",
        0x25: "L", 0x26: "J", 0x28: "K", 0x2D: "N", 0x2E: "M",
        0x7A: "F1", 0x78: "F2", 0x63: "F3", 0x76: "F4",
        0x60: "F5", 0x61: "F6", 0x62: "F7", 0x64: "F8",
        0x65: "F9", 0x6D: "F10", 0x67: "F11", 0x6F: "F12"
    ]
}

extension UserDefaults {
    func bool(forKey key: String, default defaultValue: Bool) -> Bool {
        guard let value = object(forKey: key) else { return defaultValue }
        if let boolValue = value as? Bool { return boolValue }
        if let numberValue = value as? NSNumber { return numberValue.boolValue }
        return defaultValue
    }

    func integer(forKey key: String, default defaultValue: Int) -> Int {
        guard let value = object(forKey: key) else { return defaultValue }
        if let intValue = value as? Int { return intValue }
        if let numberValue = value as? NSNumber { return numberValue.intValue }
        return defaultValue
    }
}

enum SettingsBootstrap {
    static func registerDefaults() {
        UserDefaults.standard.register(defaults: [
            UserDefaultsKey.enableClipboardHistory: Defaults.enableClipboardHistory,
            UserDefaultsKey.clipboardHotkeyModifiers: Int(Defaults.clipboardHotkeyModifiers),
            UserDefaultsKey.clipboardHotkeyKeyCode: Int(Defaults.clipboardHotkeyKeyCode),
            UserDefaultsKey.clipboardHistoryMaxItems: Defaults.clipboardHistoryMaxItems
        ])
    }
}

enum RuntimeEnvironment {
    static var isRunningTests: Bool {
        let environment = ProcessInfo.processInfo.environment
        return environment["PASTEBAY_RUNNING_XCTEST"] == "1"
            || environment["XCTestConfigurationFilePath"] != nil
    }
}
