//
//  SettingsWindowContent.swift
//  Pastebay
//

import AppKit
import SwiftUI

struct SettingsWindowContent: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        SettingsView()
            .background(SettingsWindowConfigurator())
            .onDisappear {
                appState.flushPendingSettingsForWindowClose()
            }
    }
}

private struct SettingsWindowConfigurator: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = NSView(frame: .zero)
        Task { @MainActor [weak view] in
            guard let window = view?.window else { return }
            SettingsWindowHelper.configureSettingsSceneWindow(window)
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        Task { @MainActor [weak nsView] in
            guard let window = nsView?.window else { return }
            SettingsWindowHelper.configureSettingsSceneWindow(window)
        }
    }
}
