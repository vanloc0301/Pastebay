//
//  SettingsWindowHelper.swift
//  Pastebay
//

import AppKit

@MainActor
enum SettingsWindowHelper {
    static func openSettingsWindow() {
        if focusExistingSettingsWindow() { return }

        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)

        if #available(macOS 13.0, *) {
            NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
        } else {
            NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
        }
    }

    private static func focusExistingSettingsWindow() -> Bool {
        for window in NSApp.windows {
            let identifier = window.identifier?.rawValue ?? ""
            guard identifier.hasPrefix("settings") || identifier == "com_apple_SwiftUI_Settings_window" else {
                continue
            }
            configureSettingsSceneWindow(window)
            if window.isMiniaturized {
                window.deminiaturize(nil)
            }
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return true
        }
        return false
    }

    static func configureSettingsSceneWindow(_ window: NSWindow) {
        if window.identifier?.rawValue.hasPrefix("settings") != true &&
            window.identifier?.rawValue != "com_apple_SwiftUI_Settings_window" {
            window.identifier = NSUserInterfaceItemIdentifier("settings-swiftui-scene")
        }
        window.title = "Cài đặt Pastebay"
        window.minSize = NSSize(width: SettingsLayout.windowMinSize.width, height: SettingsLayout.windowMinSize.height)
        window.contentMinSize = window.minSize
        window.hidesOnDeactivate = false
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.collectionBehavior = [.managed, .participatesInCycle, .moveToActiveSpace, .fullScreenAuxiliary]
        if #available(macOS 11.0, *) {
            window.toolbarStyle = .unified
        }
    }
}
