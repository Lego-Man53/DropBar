import AppKit

func runChecks() {
let pasteboard = NSPasteboard.withUniqueName()
defer { pasteboard.releaseGlobally() }

func check(_ passed: Bool, _ description: String) {
    guard passed else {
        fputs("FAIL: \(description)\n", stderr)
        exit(1)
    }
    print("PASS: \(description)")
}

let urls = [URL(fileURLWithPath: "/tmp/DropBar file with spaces.txt"),
            URL(fileURLWithPath: "/tmp/DropBar-second.pdf")]
pasteboard.writeObjects(urls as [NSURL])
check(DroppedFiles.read(from: pasteboard) == urls, "Multiple file URLs and spaces survive a drop")
pasteboard.clearContents()
pasteboard.writeObjects([NSURL(string: "https://example.com")!])
check(DroppedFiles.read(from: pasteboard).isEmpty, "Web links are rejected")
pasteboard.clearContents()
pasteboard.setString("plain text", forType: .string)
check(DroppedFiles.read(from: pasteboard).isEmpty, "Plain text is rejected")
pasteboard.clearContents()
check(DroppedFiles.read(from: pasteboard).isEmpty, "Empty drops are rejected")
check(NSImage(systemSymbolName: "antenna.radiowaves.left.and.right", accessibilityDescription: nil) != nil,
      "AirDrop menu bar symbol is available")
check(NSSharingService(named: .sendViaAirDrop) != nil, "System AirDrop service is available")
print("ALL CHECKS PASSED")
}

final class TestDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        DispatchQueue.main.async {
            runChecks()
            NSApp.terminate(nil)
        }
    }
}
let app = NSApplication.shared
let delegate = TestDelegate()
app.delegate = delegate
app.run()
