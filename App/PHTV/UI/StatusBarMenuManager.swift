//
//  StatusBarMenuManager.swift
//  Pastebay
//

import AppKit
import ApplicationServices

@MainActor
final class StatusBarMenuManager: NSObject, NSMenuDelegate {
    static let shared = StatusBarMenuManager()

    private var statusItem: NSStatusItem?
    private var appState: AppState { AppState.shared }

    func setup() {
        guard statusItem == nil else { return }

        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        item.button?.image = NSImage(systemSymbolName: "doc.on.clipboard", accessibilityDescription: "Pastebay")
        item.button?.image?.isTemplate = true

        let menu = NSMenu()
        menu.delegate = self
        item.menu = menu
        statusItem = item
    }

    func menuNeedsUpdate(_ menu: NSMenu) {
        menu.removeAllItems()

        menu.addItem(toggleItem(
            title: "Bật lịch sử Clipboard",
            systemImage: "doc.on.clipboard.fill",
            isOn: appState.enableClipboardHistory
        ) {
            AppState.shared.enableClipboardHistory.toggle()
        })

        menu.addItem(actionItem(
            title: "Mở Clipboard History",
            systemImage: "doc.on.clipboard",
            selector: #selector(openClipboardHistory)
        ))

        menu.addItem(.separator())

        let hasAX = AXIsProcessTrusted()
        menu.addItem(actionItem(
            title: hasAX ? "Đã cấp quyền Trợ năng" : "Cấp quyền Trợ năng",
            systemImage: hasAX ? "checkmark.shield" : "exclamationmark.shield",
            selector: #selector(openAccessibilityPreferences)
        ))

        menu.addItem(.separator())

        let settingsItem = NSMenuItem(title: "Mở Cài đặt...", action: #selector(openSettings), keyEquivalent: ",")
        settingsItem.keyEquivalentModifierMask = .command
        settingsItem.image = image("slider.horizontal.3")
        settingsItem.target = self
        menu.addItem(settingsItem)

        menu.addItem(.separator())

        let quitItem = NSMenuItem(title: "Thoát Pastebay", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.keyEquivalentModifierMask = .command
        quitItem.image = image("power")
        quitItem.target = self
        menu.addItem(quitItem)
    }

    private func actionItem(title: String, systemImage: String, selector: Selector) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: selector, keyEquivalent: "")
        item.image = image(systemImage)
        item.target = self
        return item
    }

    private func toggleItem(title: String, systemImage: String, isOn: Bool, action: @escaping () -> Void) -> NSMenuItem {
        let item = MenuCallbackItem(title: title, handler: action)
        item.image = image(systemImage)
        item.state = isOn ? .on : .off
        return item
    }

    private func image(_ systemName: String) -> NSImage? {
        NSImage(systemSymbolName: systemName, accessibilityDescription: nil)
    }

    @objc private func openClipboardHistory() {
        ClipboardHistoryManager.shared.toggleVisibility()
    }

    @objc private func openAccessibilityPreferences() {
        PastebayAccessibilityService.openAccessibilityPreferences()
    }

    @objc private func openSettings() {
        SettingsWindowOpener.requestOpenWindow()
    }

    @objc private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}

private final class MenuCallbackItem: NSMenuItem {
    private let handler: () -> Void

    init(title: String, handler: @escaping () -> Void) {
        self.handler = handler
        super.init(title: title, action: #selector(runHandler), keyEquivalent: "")
        target = self
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func runHandler() {
        handler()
    }
}
