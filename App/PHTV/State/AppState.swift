//
//  AppState.swift
//  Pastebay
//

import AppKit
import Observation

@MainActor
@Observable
final class AppState {
    static let shared = AppState()

    var enableClipboardHistory = Defaults.enableClipboardHistory {
        didSet { persistClipboardSettings(oldValue: oldValue, newValue: enableClipboardHistory) }
    }

    var clipboardHotkeyModifiersRaw = Int(Defaults.clipboardHotkeyModifiers) {
        didSet { persistClipboardSettings(oldValue: oldValue, newValue: clipboardHotkeyModifiersRaw) }
    }

    var clipboardHotkeyKeyCode = Defaults.clipboardHotkeyKeyCode {
        didSet { persistClipboardSettings(oldValue: oldValue, newValue: clipboardHotkeyKeyCode) }
    }

    var clipboardHistoryMaxItems = Defaults.clipboardHistoryMaxItems {
        didSet { persistClipboardSettings(oldValue: oldValue, newValue: clipboardHistoryMaxItems) }
    }

    var clipboardHotkeyModifiers: NSEvent.ModifierFlags {
        get { NSEvent.ModifierFlags(rawValue: UInt(clipboardHotkeyModifiersRaw)) }
        set { clipboardHotkeyModifiersRaw = Int(newValue.rawValue) }
    }

    @ObservationIgnored private var isLoadingSettings = false
    @ObservationIgnored private var notificationTask: Task<Void, Never>?

    private init() {
        SettingsBootstrap.registerDefaults()
        loadSettings()

        notificationTask = Task { @MainActor [weak self] in
            for await _ in NotificationCenter.default.notifications(named: NotificationName.applicationWillTerminate) {
                guard let self, !Task.isCancelled else { break }
                self.saveSettings()
            }
        }
    }

    func loadSettings() {
        isLoadingSettings = true
        let defaults = UserDefaults.standard

        enableClipboardHistory = defaults.bool(
            forKey: UserDefaultsKey.enableClipboardHistory,
            default: Defaults.enableClipboardHistory
        )

        clipboardHotkeyModifiersRaw = defaults.integer(
            forKey: UserDefaultsKey.clipboardHotkeyModifiers,
            default: Int(Defaults.clipboardHotkeyModifiers)
        )
        if clipboardHotkeyModifiersRaw == 0 {
            clipboardHotkeyModifiersRaw = Int(Defaults.clipboardHotkeyModifiers)
        }

        let savedKeyCode = defaults.integer(
            forKey: UserDefaultsKey.clipboardHotkeyKeyCode,
            default: Int(Defaults.clipboardHotkeyKeyCode)
        )
        clipboardHotkeyKeyCode = UInt16(savedKeyCode)

        clipboardHistoryMaxItems = ClipboardHistoryStoragePolicy.clampedMaxItems(
            defaults.integer(
                forKey: UserDefaultsKey.clipboardHistoryMaxItems,
                default: Defaults.clipboardHistoryMaxItems
            )
        )

        isLoadingSettings = false
    }

    func saveSettings() {
        let defaults = UserDefaults.standard
        defaults.set(enableClipboardHistory, forKey: UserDefaultsKey.enableClipboardHistory)
        defaults.set(clipboardHotkeyModifiersRaw, forKey: UserDefaultsKey.clipboardHotkeyModifiers)
        defaults.set(Int(clipboardHotkeyKeyCode), forKey: UserDefaultsKey.clipboardHotkeyKeyCode)
        defaults.set(
            ClipboardHistoryStoragePolicy.clampedMaxItems(clipboardHistoryMaxItems),
            forKey: UserDefaultsKey.clipboardHistoryMaxItems
        )
    }

    func flushPendingSettingsForWindowClose() {
        saveSettings()
        CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication)
    }

    func flushPendingSettingsForTermination() {
        flushPendingSettingsForWindowClose()
    }

    private func persistClipboardSettings<Value: Equatable>(oldValue: Value, newValue: Value) {
        guard oldValue != newValue, !isLoadingSettings else { return }
        saveSettings()
        NotificationCenter.default.post(name: NotificationName.clipboardHotkeySettingsChanged, object: nil)
    }
}
