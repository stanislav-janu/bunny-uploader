import AppKit

/// Draws a progress bar overlay on the Dock icon during uploads.
@MainActor
enum DockProgress {
    private static let tile = NSApp.dockTile

    /// Show aggregate upload progress (0...1) on the Dock icon.
    static func show(progress: Double) {
        let view = DockProgressView()
        view.progress = max(0, min(1, progress))
        tile.contentView = view
        tile.display()
    }

    /// Restore the plain Dock icon.
    static func clear() {
        tile.contentView = nil
        tile.display()
    }
}

/// NSView that renders the app icon with a progress bar across the bottom.
private final class DockProgressView: NSView {
    var progress: Double = 0

    override func draw(_ dirtyRect: NSRect) {
        NSApp.applicationIconImage?.draw(in: bounds)

        let barHeight = bounds.height * 0.13
        let inset = bounds.width * 0.1
        let track = NSRect(
            x: inset,
            y: bounds.height * 0.1,
            width: bounds.width - inset * 2,
            height: barHeight
        )
        let radius = barHeight / 2

        NSColor.black.withAlphaComponent(0.55).setFill()
        NSBezierPath(roundedRect: track, xRadius: radius, yRadius: radius).fill()

        let fill = NSRect(
            x: track.minX,
            y: track.minY,
            width: max(barHeight, track.width * progress),
            height: barHeight
        )
        NSColor.white.withAlphaComponent(0.95).setFill()
        NSBezierPath(roundedRect: fill, xRadius: radius, yRadius: radius).fill()
    }
}
