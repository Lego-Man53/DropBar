import AppKit


final class AppDelegate: NSObject, NSApplicationDelegate, NSSharingServiceDelegate {
    private var statusItem: NSStatusItem!
    private var dropTarget: DropTargetView!
    private var sharingService: NSSharingService?
    private let statusDropDelegate = StatusDropDelegate()
    private var dropPanel: NSPanel?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Opening the app a second time should not create another menu bar icon.
        let identifier = Bundle.main.bundleIdentifier ?? "local.yusuf.DropBar"
        if NSRunningApplication.runningApplications(withBundleIdentifier: identifier)
            .contains(where: { $0.processIdentifier != ProcessInfo.processInfo.processIdentifier }) {
            NSApp.terminate(nil)
            return
        }

        statusItem = NSStatusBar.system.statusItem(withLength: 64)
        guard let button = statusItem.button else { return }
        let icon = NSImage(systemSymbolName: "antenna.radiowaves.left.and.right", accessibilityDescription: "DropBar")
        icon?.isTemplate = true
        button.image = icon
        button.title = "Drop"
        button.imagePosition = .imageLeft
        button.toolTip = "Drop files here to AirDrop"

        dropTarget = DropTargetView(frame: button.bounds)
        dropTarget.autoresizingMask = [.width, .height]
        dropTarget.statusButton = button
        dropTarget.onDrop = { [weak self] urls in self?.share(urls) }
        dropTarget.onClick = { [weak self] in self?.showDropPanel() }
        dropTarget.onRightClick = { [weak self] in self?.showMenu() }
        button.addSubview(dropTarget)
        statusDropDelegate.target = dropTarget
        button.window?.registerForDraggedTypes([.fileURL])
        button.window?.delegate = statusDropDelegate
        showDropPanel()
    }

    private func showDropPanel() {
        if dropPanel == nil {
            let panel = NSPanel(contentRect: NSRect(x: 0, y: 0, width: 300, height: 180),
                                styleMask: [.titled, .closable, .nonactivatingPanel, .utilityWindow],
                                backing: .buffered, defer: false)
            panel.title = "DropBar — AirDrop"
            panel.isReleasedWhenClosed = false
            panel.hidesOnDeactivate = false
            panel.level = .floating
            panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
            panel.isMovableByWindowBackground = false
            let target = DropTargetView(frame: NSRect(x: 0, y: 0, width: 300, height: 180))
            target.expanded = true
            target.setAccessibilityLabel("Drop files here to AirDrop")
            target.onDrop = { [weak self] urls in self?.share(urls) }
            target.onClick = { [weak self] in self?.chooseFiles() }
            panel.contentView = target
            dropPanel = panel
        }
        guard let panel = dropPanel else { return }
        let screen = statusItem.button?.window?.screen ?? NSScreen.main
        if let visibleFrame = screen?.visibleFrame {
            let anchorX = statusItem.button?.window?.frame.midX ?? visibleFrame.midX
            let x = min(max(anchorX - panel.frame.width / 2, visibleFrame.minX + 16),
                        visibleFrame.maxX - panel.frame.width - 16)
            panel.setFrameOrigin(NSPoint(x: x, y: visibleFrame.maxY - panel.frame.height - 24))
        }
        panel.orderFrontRegardless()
    }

    private func showMenu() {
        let menu = NSMenu()
        let hint = NSMenuItem(title: "Drop files on this icon to AirDrop", action: nil, keyEquivalent: "")
        hint.isEnabled = false
        menu.addItem(hint)
        menu.addItem(.separator())
        addItem("Show Drop Area", action: #selector(showDropArea), to: menu)
        addItem("AirDrop Files…", action: #selector(chooseFiles), to: menu)
        addItem("Open AirDrop in Finder", action: #selector(openAirDrop), to: menu)
        menu.addItem(.separator())
        addItem("Quit DropBar", action: #selector(quit), to: menu)
        statusItem.button?.highlight(true)
        menu.popUp(positioning: nil, at: NSPoint(x: 0, y: -4), in: dropTarget)
        statusItem.button?.highlight(false)
    }

    private func addItem(_ title: String, action: Selector, to menu: NSMenu) {
        let item = NSMenuItem(title: title, action: action, keyEquivalent: "")
        item.target = self
        menu.addItem(item)
    }

    @objc private func chooseFiles() {
        NSApp.activate(ignoringOtherApps: true)
        let panel = NSOpenPanel()
        panel.title = "Choose files to AirDrop"
        panel.prompt = "AirDrop"
        panel.allowsMultipleSelection = true
        panel.canChooseFiles = true
        panel.canChooseDirectories = true
        if panel.runModal() == .OK { share(panel.urls) }
    }

    @objc private func showDropArea() { showDropPanel() }

    @objc private func openAirDrop() {
        NSWorkspace.shared.open(URL(fileURLWithPath:
            "/System/Library/CoreServices/Finder.app/Contents/Applications/AirDrop.app"))
    }

    @objc private func quit() { NSApp.terminate(nil) }

    private func share(_ urls: [URL]) {
        guard !urls.isEmpty else { return }
        let missing = urls.filter { !FileManager.default.fileExists(atPath: $0.path) }
        guard missing.isEmpty else {
            showError("File unavailable", detail: "Download the file to this Mac first, then try again.")
            return
        }
        guard let service = NSSharingService(named: .sendViaAirDrop),
              service.canPerform(withItems: urls) else {
            showError("AirDrop is unavailable", detail: "Check that Wi-Fi and Bluetooth are turned on, then try again.")
            return
        }
        sharingService = service
        service.delegate = self
        dropPanel?.orderOut(nil)
        NSApp.activate(ignoringOtherApps: true)
        service.perform(withItems: urls)
    }

    func sharingService(_ sharingService: NSSharingService, didShareItems items: [Any]) {
        if self.sharingService === sharingService { self.sharingService = nil }
    }

    func sharingService(_ sharingService: NSSharingService, didFailToShareItems items: [Any], error: Error) {
        if self.sharingService === sharingService { self.sharingService = nil }
        let nsError = error as NSError
        guard !(nsError.domain == NSCocoaErrorDomain && nsError.code == NSUserCancelledError) else { return }
        showError("AirDrop couldn’t send the files", detail: error.localizedDescription)
    }

    private func showError(_ title: String, detail: String) {
        NSApp.activate(ignoringOtherApps: true)
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = detail
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}

let application = NSApplication.shared
application.setActivationPolicy(.accessory)
let delegate = AppDelegate()
application.delegate = delegate
application.run()
