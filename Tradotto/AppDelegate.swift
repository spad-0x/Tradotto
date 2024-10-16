import Cocoa
import AppKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popover: NSPopover!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // Create the status item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        //statusItem?.button?.title = "Tradotto"
        statusItem?.button?.image = NSImage(named: NSImage.Name("icon_22_white"))
        statusItem?.button?.imagePosition = .imageLeading
        statusItem?.button?.target = self
        statusItem?.button?.action = #selector(menuBarButtonClicked)
        
        HotkeySolution.register()

        // Create the popover
        popover = NSPopover()
        if let viewController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "PopoverVC") as? NSViewController {
            popover.contentViewController = viewController
        } else {
            fatalError("Unable to find PopoverVC in storyboard")
        }
    }

    func showWindowWithClipboardContent() {
        DispatchQueue.main.async {
            if let button = self.statusItem?.button {
                if !self.popover.isShown {
                    self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                }
                if let viewController = self.popover.contentViewController as? ViewController {
                    let clipboard = NSPasteboard.general.string(forType: .string) ?? ""
                    viewController.inputTextField?.stringValue = clipboard
                    
                    
                    let targetLang = UtilityFunctions.getLanguageCode(from: viewController.toLanPopUpButton.titleOfSelectedItem ?? "")
                    
                    viewController.translateText(text: clipboard, targetLang: targetLang)
                }
            }
        }
    }

    @objc func menuBarButtonClicked() {
        if popover.isShown {
            popover.performClose(nil)
        } else {
            if let button = statusItem?.button {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
