import AppKit

final class DropTargetView: NSView {
    var onDrop: (([URL]) -> Void)?
    var onClick: (() -> Void)?
    var onRightClick: (() -> Void)?
    var expanded = false
    private var isReceiving = false
    weak var statusButton: NSStatusBarButton?

    override init(frame: NSRect) {
        super.init(frame: frame)
        registerForDraggedTypes([.fileURL])
        setAccessibilityElement(true)
        setAccessibilityRole(.button)
        setAccessibilityLabel("DropBar")
        setAccessibilityHelp("Drop files here to AirDrop, or click for options.")
        toolTip = "Drop files here to AirDrop"
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) is unavailable") }

    override func mouseDown(with event: NSEvent) { onClick?() }
    override func rightMouseDown(with event: NSEvent) { (onRightClick ?? onClick)?() }
    override func accessibilityPerformPress() -> Bool {
        onClick?()
        return true
    }

    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        updateDrag(sender)
    }

    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        updateDrag(sender)
    }

    private func updateDrag(_ sender: NSDraggingInfo) -> NSDragOperation {
        let accepts = sender.draggingSourceOperationMask.contains(.copy)
            && !DroppedFiles.read(from: sender.draggingPasteboard).isEmpty
        statusButton?.highlight(accepts)
        isReceiving = accepts
        needsDisplay = true
        return accepts ? .copy : []
    }

    override func draggingExited(_ sender: NSDraggingInfo?) {
        statusButton?.highlight(false)
        isReceiving = false
        needsDisplay = true
    }

    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        !DroppedFiles.read(from: sender.draggingPasteboard).isEmpty
    }

    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        statusButton?.highlight(false)
        isReceiving = false
        needsDisplay = true
        let urls = DroppedFiles.read(from: sender.draggingPasteboard)
        guard !urls.isEmpty else { return false }
        // Let AppKit finish the drag before presenting the system chooser.
        DispatchQueue.main.async { [weak self] in self?.onDrop?(urls) }
        return true
    }

    override func concludeDragOperation(_ sender: NSDraggingInfo?) {
        statusButton?.highlight(false)
        isReceiving = false
        needsDisplay = true
    }

    override func draw(_ dirtyRect: NSRect) {
        guard expanded else { return }
        NSColor.windowBackgroundColor.setFill()
        bounds.fill()
        let card = NSBezierPath(roundedRect: bounds.insetBy(dx: 12, dy: 12), xRadius: 14, yRadius: 14)
        (isReceiving ? NSColor.controlAccentColor.withAlphaComponent(0.16) : NSColor.controlAccentColor.withAlphaComponent(0.06)).setFill()
        card.fill()
        NSColor.controlAccentColor.withAlphaComponent(isReceiving ? 1 : 0.35).setStroke()
        card.lineWidth = isReceiving ? 2 : 1
        card.stroke()
        let image = NSImage(systemSymbolName: "square.and.arrow.up", accessibilityDescription: nil)?
            .withSymbolConfiguration(.init(paletteColors: [.labelColor]))
        image?.draw(in: NSRect(x: bounds.midX - 16, y: 115, width: 32, height: 36))
        drawText(isReceiving ? "Release to AirDrop" : "Drop files here", y: 78, size: 20, color: .labelColor)
        drawText("Then choose your nearby device", y: 52, size: 12, color: .secondaryLabelColor)
        drawText("or click to choose files…", y: 28, size: 12, color: .controlAccentColor)
    }

    private func drawText(_ text: String, y: CGFloat, size: CGFloat, color: NSColor) {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        (text as NSString).draw(in: NSRect(x: 16, y: y, width: bounds.width - 32, height: 28),
                               withAttributes: [.font: NSFont.systemFont(ofSize: size, weight: size > 16 ? .semibold : .regular),
                                                .foregroundColor: color, .paragraphStyle: style])
    }
}

// Status item windows can receive the drag before their button's subviews do.
// AppKit forwards a registered window's drag callbacks to its delegate.
final class StatusDropDelegate: NSObject, NSWindowDelegate {
    weak var target: DropTargetView?
    @objc func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation { target?.draggingEntered(sender) ?? [] }
    @objc func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation { target?.draggingUpdated(sender) ?? [] }
    @objc func draggingExited(_ sender: NSDraggingInfo?) { target?.draggingExited(sender) }
    @objc func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool { target?.prepareForDragOperation(sender) ?? false }
    @objc func performDragOperation(_ sender: NSDraggingInfo) -> Bool { target?.performDragOperation(sender) ?? false }
    @objc func concludeDragOperation(_ sender: NSDraggingInfo?) { target?.concludeDragOperation(sender) }
}
