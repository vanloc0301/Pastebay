//
//  SettingsWindowOpener.swift
//  Pastebay
//

import AppKit

@MainActor
enum SettingsWindowOpener {
    static func requestOpenWindow() {
        SettingsWindowHelper.openSettingsWindow()
    }
}
