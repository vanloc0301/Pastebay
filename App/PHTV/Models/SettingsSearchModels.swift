//
//  SettingsSearchModels.swift
//  PHTV
//
//  Created by Phạm Hùng Tiến on 2026.
//  Copyright © 2026 Phạm Hùng Tiến. All rights reserved.
//

import Foundation

// MARK: - Settings Search Item

struct SettingsItem: Identifiable {
    let id = UUID()
    let title: String
    let iconName: String
    let tab: SettingsTab
    let keywords: [String]

    static let allItems: [SettingsItem] = [
        SettingsItem(
            title: "Lịch sử Clipboard", iconName: "doc.on.clipboard.fill", tab: .clipboardHistory,
            keywords: ["clipboard", "pasteboard", "lịch sử", "sao chép", "copy", "paste", "dán", "phím tắt", "hotkey"]),
        SettingsItem(
            title: "Số mục Clipboard tối đa", iconName: "list.number", tab: .clipboardHistory,
            keywords: ["clipboard", "max items", "số mục", "lưu", "history", "500"]),
        SettingsItem(
            title: "Quyền Trợ năng", iconName: "checkmark.shield.fill", tab: .system,
            keywords: ["accessibility", "permission", "quyền", "trợ năng", "cấp quyền", "system settings"])
    ]
}

// MARK: - Settings Tabs

enum SettingsTab: String, CaseIterable, Identifiable {
    case typing = "Bộ gõ"
    case phtvPicker = "PHTV Picker"
    case clipboardHistory = "Lịch sử Clipboard"
    case keyboardCleaning = "Lau bàn phím"
    case hotkeys = "Phím tắt"
    case macro = "Gõ tắt"
    case apps = "Ứng dụng"
    case system = "Hệ thống"
    case bugReport = "Báo lỗi"
    case about = "Thông tin"

    nonisolated var id: String { rawValue }
    nonisolated var title: String { rawValue }

    nonisolated var iconName: String {
        switch self {
        case .typing: return "keyboard"
        case .phtvPicker: return "smiley"
        case .clipboardHistory: return "doc.on.clipboard"
        case .keyboardCleaning: return "keyboard.badge.eye"
        case .hotkeys: return "command"
        case .macro: return "text.badge.checkmark"
        case .apps: return "square.stack.3d.up"
        case .system: return "gear"
        case .bugReport: return "ladybug.fill"
        case .about: return "info.circle"
        }
    }
}

// MARK: - Settings Sidebar Sections

enum SettingsTabSection: String, CaseIterable, Identifiable {
    case typing = "Nhập liệu"
    case system = "Hệ thống"
    case support = "Hỗ trợ"

    nonisolated var id: String { rawValue }
    nonisolated var title: String { rawValue }

    nonisolated var tabs: [SettingsTab] {
        switch self {
        case .typing:
            return [.clipboardHistory]
        case .system:
            return [.system]
        case .support:
            return []
        }
    }
}
