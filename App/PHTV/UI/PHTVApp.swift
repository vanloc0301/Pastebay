//
//  PHTVApp.swift
//  Pastebay
//

import SwiftUI

@main
struct PHTVApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    init() {
        SettingsBootstrap.registerDefaults()
    }

    var body: some Scene {
        Settings {
            SettingsWindowContent()
                .environment(AppState.shared)
                .frame(
                    minWidth: SettingsLayout.windowMinSize.width,
                    idealWidth: SettingsLayout.windowIdealSize.width,
                    minHeight: SettingsLayout.windowMinSize.height,
                    idealHeight: SettingsLayout.windowIdealSize.height
                )
        }
        .commands {
            CommandGroup(replacing: .appSettings) {
                SettingsLink {
                    Text("Cài đặt Pastebay...")
                }
                .keyboardShortcut(",", modifiers: .command)
            }
        }
    }
}
