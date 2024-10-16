import Carbon
import AppKit

extension String {
    public var fourCharCodeValue: Int {
        var result: Int = 0
        if let data = self.data(using: String.Encoding.macOSRoman) {
            data.withUnsafeBytes({ (rawBytes) in
                let bytes = rawBytes.bindMemory(to: UInt8.self)
                for i in 0 ..< data.count {
                    result = result << 8 + Int(bytes[i])
                }
            })
        }
        return result
    }
}

class HotkeySolution {
    static func getCarbonFlagsFromCocoaFlags(cocoaFlags: NSEvent.ModifierFlags) -> UInt32 {
        let flags = cocoaFlags.rawValue
        var newFlags: Int = 0

        if ((flags & NSEvent.ModifierFlags.control.rawValue) > 0) {
            newFlags |= controlKey
        }

        if ((flags & NSEvent.ModifierFlags.command.rawValue) > 0) {
            newFlags |= cmdKey
        }

        if ((flags & NSEvent.ModifierFlags.shift.rawValue) > 0) {
            newFlags |= shiftKey
        }

        if ((flags & NSEvent.ModifierFlags.option.rawValue) > 0) {
            newFlags |= optionKey
        }

        if ((flags & NSEvent.ModifierFlags.capsLock.rawValue) > 0) {
            newFlags |= alphaLock
        }

        return UInt32(newFlags)
    }

    static func register() {
        var hotKeyRef: EventHotKeyRef?
        let modifierFlags: UInt32 = getCarbonFlagsFromCocoaFlags(cocoaFlags: [.option])
        let keyCode = kVK_ANSI_C
        var gMyHotKeyID = EventHotKeyID()

        gMyHotKeyID.id = UInt32(keyCode)
        gMyHotKeyID.signature = OSType("swat".fourCharCodeValue)

        var eventType = EventTypeSpec()
        eventType.eventClass = OSType(kEventClassKeyboard)
        eventType.eventKind = OSType(kEventHotKeyReleased)

        InstallEventHandler(GetApplicationEventTarget(), {
            (nextHandler, theEvent, userData) -> OSStatus in
            DispatchQueue.main.async {
                if let appDelegate = NSApp.delegate as? AppDelegate {
                    appDelegate.showWindowWithClipboardContent()
                }
            }
            return noErr
        }, 1, &eventType, nil, nil)

        let status = RegisterEventHotKey(UInt32(keyCode),
                                         modifierFlags,
                                         gMyHotKeyID,
                                         GetApplicationEventTarget(),
                                         0,
                                         &hotKeyRef)
        assert(status == noErr)
    }
}
