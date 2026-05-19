import Cocoa
import InputMethodKit

private var inputMethodServer: IMKServer?

let bundle = Bundle.main
let bundleIdentifier = bundle.bundleIdentifier ?? "com.phamhungtien.phtv.inputmethod"
let connectionName = bundle.object(forInfoDictionaryKey: "InputMethodConnectionName") as? String
    ?? "PHTVInputMethod_Connection"

inputMethodServer = IMKServer(name: connectionName, bundleIdentifier: bundleIdentifier)
NSApplication.shared.run()
