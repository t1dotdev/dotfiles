import Carbon

let sources = TISCreateInputSourceList(nil, false).takeRetainedValue() as! [TISInputSource]
let current = TISCopyCurrentKeyboardInputSource().takeRetainedValue()
let currentID = Unmanaged<CFString>.fromOpaque(TISGetInputSourceProperty(current, kTISPropertyInputSourceID)).takeUnretainedValue() as String

var selectables: [TISInputSource] = []
for source in sources {
    guard let catPtr = TISGetInputSourceProperty(source, kTISPropertyInputSourceCategory),
          let selPtr = TISGetInputSourceProperty(source, kTISPropertyInputSourceIsSelectCapable) else { continue }
    let cat = Unmanaged<CFString>.fromOpaque(catPtr).takeUnretainedValue() as String
    let sel = Unmanaged<CFBoolean>.fromOpaque(selPtr).takeUnretainedValue()
    if cat == (kTISCategoryKeyboardInputSource as String) && CFBooleanGetValue(sel) {
        selectables.append(source)
    }
}

guard selectables.count > 1 else { exit(0) }

var currentIdx = 0
for (i, source) in selectables.enumerated() {
    guard let idPtr = TISGetInputSourceProperty(source, kTISPropertyInputSourceID) else { continue }
    let id = Unmanaged<CFString>.fromOpaque(idPtr).takeUnretainedValue() as String
    if id == currentID { currentIdx = i; break }
}

let nextIdx = (currentIdx + 1) % selectables.count
TISSelectInputSource(selectables[nextIdx])
