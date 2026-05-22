//
//  HotkeyCaptureComponents.swift
//  Pastebay
//

import AppKit
import SwiftUI

struct ModifierKeyButton: View {
    let symbol: String
    let name: String
    @Binding var isOn: Bool

    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            HStack(spacing: 4) {
                Text(symbol)
                    .font(.system(size: 14, weight: .semibold))
                if !name.isEmpty {
                    Text(name)
                        .font(.system(size: 11))
                }
            }
            .frame(maxWidth: .infinity)
        }
        .settingsControlButtonStyle(isProminent: isOn)
        .controlSize(.small)
    }
}

struct SettingsShortcutRecorderLabel: View {
    let text: String
    let isRecording: Bool

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: isRecording ? "keyboard.badge.ellipsis" : "keyboard")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(isRecording ? Color.accentColor : .secondary)
                .frame(width: 16)

            Text(text)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(isRecording ? Color.accentColor : .primary)
                .lineLimit(1)
                .minimumScaleFactor(0.85)

            Spacer(minLength: 0)
        }
    }
}

struct SettingsShortcutRecorderButtonStyle: ButtonStyle {
    let isRecording: Bool
    @Environment(\.colorScheme) private var colorScheme

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 10)
            .frame(width: SettingsLayout.rowControlColumnWidth, height: 32, alignment: .leading)
            .background {
                PHTVRoundedRect(cornerRadius: 7)
                    .fill(backgroundColor)
                    .overlay {
                        PHTVRoundedRect(cornerRadius: 7)
                            .stroke(borderColor, lineWidth: isRecording ? 1.5 : 1)
                    }
            }
            .contentShape(PHTVRoundedRect(cornerRadius: 7))
            .opacity(configuration.isPressed ? 0.82 : 1)
    }

    private var backgroundColor: Color {
        if isRecording {
            return Color.accentColor.opacity(colorScheme == .dark ? 0.18 : 0.12)
        }
        return Color(NSColor.controlBackgroundColor)
    }

    private var borderColor: Color {
        if isRecording {
            return Color.accentColor.opacity(colorScheme == .dark ? 0.8 : 0.65)
        }
        return Color(NSColor.separatorColor).opacity(colorScheme == .dark ? 0.9 : 0.65)
    }
}

final class SettingsHotkeyCaptureView: NSView {
    var onKeyPress: ((UInt16) -> Void)?
    var isRecording = false {
        didSet {
            if isRecording {
                window?.makeFirstResponder(self)
            }
        }
    }

    override var acceptsFirstResponder: Bool { true }

    override func keyDown(with event: NSEvent) {
        guard isRecording else {
            super.keyDown(with: event)
            return
        }

        if event.keyCode == KeyCode.escape {
            isRecording = false
            return
        }

        onKeyPress?(event.keyCode)
    }
}
