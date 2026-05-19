import SwiftUI
import AppKit

// MARK: - Settings Window Controller
final class PHTVSettingsWindowController: NSWindowController {
    static let shared = PHTVSettingsWindowController()
    
    private var myWindow: NSWindow?
    
    init() {
        super.init(window: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func displayWindow() {
        if let window = myWindow {
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        
        let contentView = PHTVSettingsView()
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 450),
            styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
        window.center()
        window.title = "Cấu hình PHTV"
        window.isReleasedWhenClosed = false
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        
        // Premium translucent behind-window blur (Vibrancy)
        let visualEffect = NSVisualEffectView()
        visualEffect.blendingMode = .behindWindow
        visualEffect.state = .active
        visualEffect.material = .hudWindow
        
        window.contentView = visualEffect
        
        let hostingView = NSHostingView(rootView: contentView)
        hostingView.frame = visualEffect.bounds
        hostingView.autoresizingMask = [.width, .height]
        visualEffect.addSubview(hostingView)
        
        myWindow = window
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        
        // Listen to window closing to clean up reference
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(windowWillClose(_:)),
            name: NSWindow.willCloseNotification,
            object: window
        )
    }
    
    @objc private func windowWillClose(_ notification: Notification) {
        myWindow = nil
    }
}

// MARK: - SwiftUI Settings View
struct PHTVSettingsView: View {
    @State private var activeTab: SettingsTab = .inputStyle
    @State private var inputStyle: PHTVInputStyle = .telex
    @State private var outputEncoding: PHTVOutputEncoding = .unicode
    @State private var showSavedAlert = false
    
    enum SettingsTab: String, CaseIterable {
        case inputStyle = "Kiểu gõ"
        case encoding = "Bảng mã"
        
        var icon: String {
            switch self {
            case .inputStyle: return "keyboard"
            case .encoding: return "character.textbox"
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Premium Header acting as Custom Title Bar
            HStack {
                HStack(spacing: 12) {
                    Image(nsImage: NSApp.applicationIconImage)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .cornerRadius(8)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Bộ gõ PHTV")
                            .font(.system(.headline, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        Text("Cấu hình bộ gõ độc lập")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // Custom Modern Tab Bar
                HStack(spacing: 4) {
                    ForEach(SettingsTab.allCases, id: \.self) { tab in
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                activeTab = tab
                            }
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: tab.icon)
                                    .font(.system(size: 11, weight: .semibold))
                                Text(tab.rawValue)
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(activeTab == tab ? Color.white.opacity(0.15) : Color.clear)
                            .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(4)
                .background(Color.black.opacity(0.15))
                .cornerRadius(10)
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 16)
            
            Divider()
                .background(Color.white.opacity(0.1))
            
            // Preferences Content Pane
            ScrollView {
                VStack(spacing: 20) {
                    if activeTab == .inputStyle {
                        inputStyleTab
                    } else {
                        encodingTab
                    }
                }
                .padding(24)
            }
            .frame(maxHeight: .infinity)
            
            Divider()
                .background(Color.white.opacity(0.1))
            
            // Premium Footer & Auto-save Alert
            HStack {
                if showSavedAlert {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 12, weight: .bold))
                        Text("Đã tự động áp dụng")
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundColor(.green)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                
                Spacer()
                
                Button("Đóng") {
                    if let window = NSApp.windows.first(where: { $0.title == "Cấu hình PHTV" }) {
                        window.close()
                    }
                }
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .buttonStyle(.borderedProminent)
                .controlSize(.regular)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(Color.black.opacity(0.08))
        }
        .frame(width: 500, height: 450)
        .onAppear {
            let config = PHTVInputMethodPreferences.currentConfiguration()
            self.inputStyle = config.inputStyle
            self.outputEncoding = config.outputEncoding
        }
    }
    
    // MARK: - Kiểu gõ Tab View
    private var inputStyleTab: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Chọn kiểu gõ Tiếng Việt:")
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundColor(.secondary)
                .padding(.bottom, 2)
            
            ForEach(PHTVInputStyle.allCases, id: \.self) { style in
                let isSelected = inputStyle == style
                Button(action: {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                        inputStyle = style
                        save()
                    }
                }) {
                    HStack(spacing: 16) {
                        // Custom Interactive Radio Icon
                        ZStack {
                            Circle()
                                .stroke(isSelected ? Color.accentColor : Color.secondary.opacity(0.4), lineWidth: 2)
                                .frame(width: 18, height: 18)
                            if isSelected {
                                Circle()
                                    .fill(Color.accentColor)
                                    .frame(width: 10, height: 10)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(style.displayName)
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                            Text(styleDescription(for: style))
                                .font(.system(size: 11, design: .rounded))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.leading)
                        }
                        
                        Spacer()
                        
                        // Tag Descriptor
                        Text(style.displayName.uppercased())
                            .font(.system(size: 9, weight: .bold, design: .rounded))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(isSelected ? Color.accentColor.opacity(0.2) : Color.white.opacity(0.08))
                            .foregroundColor(isSelected ? .accentColor : .secondary)
                            .cornerRadius(6)
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(isSelected ? Color.accentColor.opacity(0.06) : Color.white.opacity(0.03))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.accentColor.opacity(0.3) : Color.white.opacity(0.05), lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    // MARK: - Bảng mã Tab View
    private var encodingTab: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Chọn bảng mã đầu ra:")
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundColor(.secondary)
                .padding(.bottom, 2)
            
            ForEach(PHTVOutputEncoding.allCases, id: \.self) { encoding in
                let isSelected = outputEncoding == encoding
                Button(action: {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                        outputEncoding = encoding
                        save()
                    }
                }) {
                    HStack(spacing: 16) {
                        // Custom Interactive Radio Icon
                        ZStack {
                            Circle()
                                .stroke(isSelected ? Color.accentColor : Color.secondary.opacity(0.4), lineWidth: 2)
                                .frame(width: 18, height: 18)
                            if isSelected {
                                Circle()
                                    .fill(Color.accentColor)
                                    .frame(width: 10, height: 10)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(encoding.displayName)
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                            Text(encodingDescription(for: encoding))
                                .font(.system(size: 11, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(isSelected ? Color.accentColor.opacity(0.06) : Color.white.opacity(0.03))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.accentColor.opacity(0.3) : Color.white.opacity(0.05), lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    // MARK: - Descriptions
    private func styleDescription(for style: PHTVInputStyle) -> String {
        switch style {
        case .telex:
            return "Kiểu gõ tiếng Việt phổ biến nhất. Dùng phím chữ (s, f, r, x, j, z) để gõ dấu."
        case .vni:
            return "Kiểu gõ dùng phím số (1, 2, 3, 4, 5, 6, 7, 8, 9, 0) để gõ dấu."
        case .simpleTelex1:
            return "Telex đơn giản hóa. Phím 'w' tự động thêm dấu móc cho 'ư' và 'ơ'."
        case .simpleTelex2:
            return "Telex mở rộng. Tự động thêm dấu móc và linh hoạt xử lý từ."
        }
    }
    
    private func encodingDescription(for encoding: PHTVOutputEncoding) -> String {
        switch encoding {
        case .unicode:
            return "Tiêu chuẩn quốc tế hiện đại. Tương thích hoàn hảo với web và hệ điều hành mới."
        case .tcvn3:
            return "Bảng mã TCVN3 (ABC) cũ dùng cho một số tài liệu hành chính nhà nước trước đây."
        case .vniWindows:
            return "Bảng mã 2-byte cũ của VNI sử dụng các phông chữ có tiền tố 'VNI-'."
        case .unicodeComposite:
            return "Unicode tổ hợp dùng trong một số phần mềm hoặc hệ thống cũ hơn."
        case .cp1258:
            return "Bảng mã trang mã địa phương tiếng Việt của Microsoft Windows."
        }
    }
    
    // MARK: - Save Settings
    private func save() {
        let config = PHTVInputMethodConfiguration(inputStyle: inputStyle, outputEncoding: outputEncoding)
        PHTVInputMethodPreferences.saveConfiguration(config)
        
        withAnimation(.easeInOut(duration: 0.15)) {
            showSavedAlert = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation(.easeInOut(duration: 0.25)) {
                showSavedAlert = false
            }
        }
    }
}
