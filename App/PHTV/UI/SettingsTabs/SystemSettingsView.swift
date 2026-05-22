//
//  SystemSettingsView.swift
//  Pastebay
//

import AppKit
import ApplicationServices
import SwiftUI

struct SystemSettingsView: View {
    @State private var hasAccessibilityPermission = AXIsProcessTrusted()

    var body: some View {
        ScrollView {
            LazyVStack(spacing: SettingsLayout.sectionSpacing) {
                SettingsCard(
                    title: "Quyền Trợ năng",
                    subtitle: "Cho phép Pastebay gửi lệnh dán vào ứng dụng đang dùng",
                    icon: "checkmark.shield.fill"
                ) {
                    VStack(spacing: 0) {
                        HStack(spacing: 12) {
                            Image(systemName: hasAccessibilityPermission ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(hasAccessibilityPermission ? .green : .orange)
                                .frame(width: 28)

                            VStack(alignment: .leading, spacing: 3) {
                                Text(hasAccessibilityPermission ? "Đã cấp quyền Trợ năng" : "Chưa cấp quyền Trợ năng")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Text("Quyền này chỉ dùng để paste lại mục clipboard đã chọn.")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer(minLength: 12)

                            Button(hasAccessibilityPermission ? "Mở lại" : "Cấp quyền") {
                                PastebayAccessibilityService.openAccessibilityPreferences()
                                refreshAccessibilityStatus()
                            }
                        }
                        .padding(.vertical, SettingsLayout.rowVerticalPadding)

                        SettingsDivider()

                        SettingsButtonRow(
                            icon: "arrow.clockwise.circle.fill",
                            iconColor: .accentColor,
                            title: "Kiểm tra lại trạng thái",
                            subtitle: "Cập nhật trạng thái sau khi bật quyền trong System Settings",
                            action: refreshAccessibilityStatus
                        )
                    }
                }

                Spacer(minLength: SettingsLayout.sectionSpacing)
            }
            .settingsPageFrame()
        }
        .settingsBackground()
        .task {
            await observeAccessibilityChanges()
        }
        .onAppear(perform: refreshAccessibilityStatus)
    }

    private func refreshAccessibilityStatus() {
        hasAccessibilityPermission = AXIsProcessTrusted()
    }

    @MainActor
    private func observeAccessibilityChanges() async {
        for await _ in DistributedNotificationCenter.default().notifications(
            named: Notification.Name("com.apple.accessibility.api")
        ) {
            guard !Task.isCancelled else { return }
            refreshAccessibilityStatus()
        }
    }
}

#Preview {
    SystemSettingsView()
}
