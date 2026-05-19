import Foundation

enum PHTVInputStyle: Int, CaseIterable {
    case telex = 0
    case vni = 1
    case simpleTelex1 = 2
    case simpleTelex2 = 3

    var displayName: String {
        switch self {
        case .telex:
            return "Telex"
        case .vni:
            return "VNI"
        case .simpleTelex1:
            return "Simple Telex 1"
        case .simpleTelex2:
            return "Simple Telex 2"
        }
    }
}

enum PHTVOutputEncoding: Int, CaseIterable {
    case unicode = 0
    case tcvn3 = 1
    case vniWindows = 2
    case unicodeComposite = 3
    case cp1258 = 4

    var displayName: String {
        switch self {
        case .unicode:
            return "Unicode"
        case .tcvn3:
            return "TCVN3"
        case .vniWindows:
            return "VNI Windows"
        case .unicodeComposite:
            return "Unicode Composite"
        case .cp1258:
            return "Vietnamese Locale CP1258"
        }
    }
}

struct PHTVInputMethodConfiguration {
    var inputStyle: PHTVInputStyle
    var outputEncoding: PHTVOutputEncoding

    static let fallback = PHTVInputMethodConfiguration(
        inputStyle: .telex,
        outputEncoding: .unicode
    )
}

enum PHTVInputMethodPreferences {
    private static let inputMethodKey = "InputType"
    private static let codeTableKey = "CodeTable"
    private static let preferenceDomains = [
        "com.phamhungtien.phtv.inputmethod",
        "com.phamhungtien.phtv",
        "com.phamhungtien.phtv.debug",
    ]

    static func currentConfiguration() -> PHTVInputMethodConfiguration {
        var inputMethodValue = UserDefaults.standard.object(forKey: inputMethodKey) as? Int
        var codeTableValue = UserDefaults.standard.object(forKey: codeTableKey) as? Int

        for domain in preferenceDomains where inputMethodValue == nil || codeTableValue == nil {
            guard let defaults = UserDefaults(suiteName: domain) else { continue }
            if inputMethodValue == nil {
                inputMethodValue = defaults.object(forKey: inputMethodKey) as? Int
            }
            if codeTableValue == nil {
                codeTableValue = defaults.object(forKey: codeTableKey) as? Int
            }
        }

        return PHTVInputMethodConfiguration(
            inputStyle: PHTVInputStyle(rawValue: inputMethodValue ?? PHTVInputMethodConfiguration.fallback.inputStyle.rawValue)
                ?? PHTVInputMethodConfiguration.fallback.inputStyle,
            outputEncoding: PHTVOutputEncoding(rawValue: codeTableValue ?? PHTVInputMethodConfiguration.fallback.outputEncoding.rawValue)
                ?? PHTVInputMethodConfiguration.fallback.outputEncoding
        )
    }

    static func saveConfiguration(_ config: PHTVInputMethodConfiguration) {
        let domain = "com.phamhungtien.phtv"
        
        // Write to App Suite defaults
        if let defaults = UserDefaults(suiteName: domain) {
            defaults.set(config.inputStyle.rawValue, forKey: "InputType")
            defaults.set(config.outputEncoding.rawValue, forKey: "CodeTable")
            defaults.synchronize()
        }
        
        // Write to standard defaults
        UserDefaults.standard.set(config.inputStyle.rawValue, forKey: "InputType")
        UserDefaults.standard.set(config.outputEncoding.rawValue, forKey: "CodeTable")
        UserDefaults.standard.synchronize()
        
        // Post notifications
        NotificationCenter.default.post(
            name: NSNotification.Name("InputMethodChanged"),
            object: NSNumber(value: config.inputStyle.rawValue)
        )
        NotificationCenter.default.post(
            name: NSNotification.Name("CodeTableChanged"),
            object: NSNumber(value: config.outputEncoding.rawValue)
        )
        NotificationCenter.default.post(
            name: NSNotification.Name("PHTVSettingsChanged"),
            object: nil
        )
    }
}
