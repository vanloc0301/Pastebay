import Foundation
import InputMethodKit

@objc(PHTVInputController)
final class PHTVInputController: IMKInputController {
    private var composingBuffer = ""

    @objc(inputText:client:)
    override func inputText(_ string: String!, client sender: Any!) -> Bool {
        // Skeleton behavior: let the client handle normal text until the PHTV
        // engine is wired into this InputMethodKit target.
        composingBuffer.removeAll(keepingCapacity: true)
        return false
    }

    @objc(commitComposition:)
    override func commitComposition(_ sender: Any!) {
        composingBuffer.removeAll(keepingCapacity: true)
    }

    @objc(composedString:)
    override func composedString(_ sender: Any!) -> Any! {
        composingBuffer
    }

    @objc(originalString:)
    override func originalString(_ sender: Any!) -> NSAttributedString! {
        NSAttributedString(string: composingBuffer)
    }

    @objc(candidates:)
    override func candidates(_ sender: Any!) -> [Any]! {
        []
    }
}
