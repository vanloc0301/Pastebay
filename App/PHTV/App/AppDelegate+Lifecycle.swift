//
//  AppDelegate+Lifecycle.swift
//  PHTV
//
//  Application lifecycle coordination.
//  Created by Phạm Hùng Tiến on 2026.
//  Copyright © 2026 Phạm Hùng Tiến. All rights reserved.
//

import AppKit
import ApplicationServices
import Darwin
import Foundation

private let phtvDefaultsKeyShowIconOnDock = "vShowIconOnDock"
private let phtvDefaultsKeyShowUIOnStartup = "ShowUIOnStartup"
private let phtvDefaultsKeyNonFirstTime = "NonFirstTime"
private let phtvDefaultsKeyInitialToolTipDelay = "NSInitialToolTipDelay"

private let phtvNotificationShowSettings = NotificationName.showSettings
private let phtvNotificationApplicationWillTerminate = NotificationName.applicationWillTerminate

private func phtvProcessOwnerUID(_ pid: pid_t) -> uid_t? {
    var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, pid]
    var info = kinfo_proc()
    var size = MemoryLayout<kinfo_proc>.stride
    let result = mib.withUnsafeMutableBufferPointer { pointer in
        sysctl(pointer.baseAddress, u_int(pointer.count), &info, &size, nil, 0)
    }
    guard result == 0, size >= MemoryLayout<kinfo_proc>.stride else { return nil }
    return info.kp_eproc.e_ucred.cr_uid
}

private func phtvShouldTerminateExistingInstance(_ app: NSRunningApplication, currentBundleID: String?) -> Bool {
    guard app.bundleIdentifier == currentBundleID,
          app.processIdentifier != ProcessInfo.processInfo.processIdentifier else {
        return false
    }
    guard let ownerUID = phtvProcessOwnerUID(app.processIdentifier) else { return false }
    return ownerUID == getuid()
}

func phtvIsRunningUnderXCTest() -> Bool {
    let environment = ProcessInfo.processInfo.environment
    return environment["PHTV_RUNNING_XCTEST"] == "1"
        || environment["XCTestConfigurationFilePath"] != nil
        || NSClassFromString("XCTestCase") != nil
        || NSClassFromString("XCTest.XCTestCase") != nil
}

@MainActor @objc extension AppDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        _ = notification
        NSLog("[AppDelegate] Clipboard History app launch started")

        lastInputMethod = -1
        lastCodeTable = -1
        isUpdatingUI = false

        savedLanguageBeforeExclusion = 0
        previousBundleIdentifier = nil
        isInExcludedApp = false

        savedSendKeyStepByStepBeforeApp = false
        isInSendKeyStepByStepApp = false

        isUpdatingLanguage = false
        isUpdatingInputType = false
        isUpdatingCodeTable = false

        SettingsBootstrap.registerDefaults()

        if phtvIsRunningUnderXCTest() {
            setupSwiftUIBridge()
            NSLog("[AppDelegate] XCTest host mode: skipping app launch side effects")
            return
        }

        let defaults = UserDefaults.standard
        let isFirstLaunch = !defaults.bool(forKey: phtvDefaultsKeyNonFirstTime)

        defaults.set(50, forKey: phtvDefaultsKeyInitialToolTipDelay)

        let runningApps = NSWorkspace.shared.runningApplications
        let currentBundleID = Bundle.main.bundleIdentifier

        for app in runningApps where phtvShouldTerminateExistingInstance(app, currentBundleID: currentBundleID) {
            NSLog("Found existing instance (PID: %d), terminating it...", app.processIdentifier)
            app.terminate()
            break
        }

        let showDockIcon = defaults.bool(forKey: phtvDefaultsKeyShowIconOnDock)
        NSApp.setActivationPolicy(showDockIcon ? .regular : .accessory)

        setupSwiftUIBridge()

        // Clipboard-only build: keep the status item, settings bridge, clipboard hotkey,
        // and Accessibility prompt. All typing engine, macro, picker, updater, and
        // compatibility runtimes are intentionally left inactive.
        StatusBarMenuManager.shared.setup()
        registerSupportedNotification()
        ClipboardHotkeyBridge.initializeClipboardHotkeyManager()
        for delay in [0.0, 0.25, 0.8] {
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(delay))
                guard !Task.isCancelled else { return }
                ClipboardHotkeyBridge.refreshClipboardHotkeyRegistration()
            }
        }

        if !AXIsProcessTrusted() {
            NotificationCenter.default.post(name: phtvNotificationShowSettings, object: nil)
            PHTVAccessibilityService.requestAccessibilityPrompt()
        }

        if isFirstLaunch {
            defaults.set(1, forKey: phtvDefaultsKeyNonFirstTime)
            NSLog("[AppDelegate] First launch: marked NonFirstTime")
        }

        syncRunOnStartupStatus(withFirstLaunch: isFirstLaunch)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        // Keep the app alive as a menu bar agent when the settings window is closed.
        return false
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        _ = sender
        _ = flag

        onControlPanelSelected()
        return true
    }

    func applicationWillTerminate(_ notification: Notification) {
        _ = notification

        AppState.shared.flushPendingSettingsForTermination()
        permissionGuidancePresentationTask?.cancel()
        permissionGuidancePresentationTask = nil
        cancelEventTapRecovery(reason: "applicationWillTerminate")
        cancelManagedNotificationTasks()
        stopInputSourceMonitoring()
        stopAccessibilityMonitoring()
        stopHealthCheckMonitoring()

        PHTVManager.clearAXTestFlag()

        NotificationCenter.default.post(name: phtvNotificationApplicationWillTerminate, object: nil)
    }
}
