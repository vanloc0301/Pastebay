//
//  ViewModifiers.swift
//  Pastebay
//

import SwiftUI

struct PHTVRoundedRect: InsettableShape {
    var cornerRadius: CGFloat
    var style: RoundedCornerStyle = .continuous
    var insetAmount: CGFloat = 0

    func inset(by amount: CGFloat) -> PHTVRoundedRect {
        var copy = self
        copy.insetAmount += amount
        return copy
    }

    func path(in rect: CGRect) -> Path {
        let insetRect = rect.insetBy(dx: insetAmount, dy: insetAmount)
        let radius = max(0, cornerRadius - insetAmount)
        return RoundedRectangle(cornerRadius: radius, style: style).path(in: insetRect)
    }
}

extension View {
    @ViewBuilder
    func settingsControlButtonStyle(isProminent: Bool = false) -> some View {
        if isProminent {
            buttonStyle(.borderedProminent)
        } else {
            buttonStyle(.bordered)
        }
    }
}

struct GlassCloseButton: View {
    let action: () -> Void
    var size: CGFloat = 28
    var iconSize: CGFloat = 11

    @State private var isHovering = false

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.red.opacity(isHovering ? 0.25 : 0.15))
                    .overlay(
                        Circle()
                            .stroke(Color.red.opacity(isHovering ? 0.35 : 0.2), lineWidth: 1)
                    )
                Image(systemName: "xmark")
                    .font(.system(size: iconSize, weight: .bold))
                    .foregroundColor(.red)
                    .scaleEffect(isHovering ? 1.1 : 1.0)
            }
            .frame(width: size, height: size)
            .animation(.easeOut(duration: 0.15), value: isHovering)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovering = hovering
        }
    }
}
