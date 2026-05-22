//
//  AppDelegate.swift
//  Pastebay
//

import AppKit
import ApplicationServices

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    static func current() -> AppDelegate? {
        NSApp.delegate as? AppDelegate
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        _ = notification

        SettingsBootstrap.registerDefaults()
        _ = AppState.shared

        if RuntimeEnvironment.isRunningTests {
            return
        }

        StatusBarMenuManager.shared.setup()
        ClipboardHotkeyManager.shared.refreshRegistrationFromAppState()

        NSApp.setActivationPolicy(.accessory)

        if !AXIsProcessTrusted() {
            SettingsWindowOpener.requestOpenWindow()
        }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        false
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        SettingsWindowOpener.requestOpenWindow()
        return true
    }

    func applicationWillTerminate(_ notification: Notification) {
        _ = notification
        AppState.shared.flushPendingSettingsForTermination()
        NotificationCenter.default.post(name: NotificationName.applicationWillTerminate, object: nil)
    }
}
