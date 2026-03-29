import CoreGraphics

if let windows = CGWindowListCopyWindowInfo(.optionOnScreenOnly, kCGNullWindowID) as? [[String: Any]] {
    for w in windows {
        guard let wid = w[kCGWindowNumber as String] as? Int,
              let bounds = w[kCGWindowBounds as String] as? [String: CGFloat],
              let layer = w[kCGWindowLayer as String] as? Int,
              layer == 0 else { continue }
        let x = Int(bounds["X"] ?? 0)
        let y = Int(bounds["Y"] ?? 0)
        print("\(wid)|\(x)|\(y)")
    }
}
