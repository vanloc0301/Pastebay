//
//  SettingsView.swift
//  Pastebay
//

import SwiftUI

struct SettingsView: View {
    @State private var selectedTab: SettingsTab = .clipboard

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedTab) {
                Label("Clipboard History", systemImage: "doc.on.clipboard")
                    .tag(SettingsTab.clipboard)
                Label("Trợ năng", systemImage: "checkmark.shield")
                    .tag(SettingsTab.accessibility)
            }
            .listStyle(.sidebar)
            .navigationSplitViewColumnWidth(
                min: SettingsLayout.sidebarMinWidth,
                ideal: SettingsLayout.sidebarIdealWidth,
                max: SettingsLayout.sidebarMaxWidth
            )
        } detail: {
            Group {
                switch selectedTab {
                case .clipboard:
                    ClipboardHistorySettingsView()
                case .accessibility:
                    SystemSettingsView()
                }
            }
            .frame(minWidth: SettingsLayout.detailMinWidth, minHeight: SettingsLayout.detailMinHeight)
        }
        .navigationSplitViewStyle(.balanced)
    }
}

private enum SettingsTab: Hashable {
    case clipboard
    case accessibility
}

#Preview {
    SettingsView()
        .environment(AppState.shared)
}
