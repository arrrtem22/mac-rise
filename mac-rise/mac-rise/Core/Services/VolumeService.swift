//
//  VolumeService.swift
//  mac-rise
//
//  Controls macOS system volume via NSAppleScript.
//  Replicates the osascript volume control from wake-alarm.sh.
//

import Foundation

protocol VolumeServiceProtocol {
    func getCurrentVolume() -> Int
    func setVolume(_ level: Int, maxLevel: Int)
    func setVolumeIfBelow(_ level: Int, maxLevel: Int)
}

final class VolumeService: VolumeServiceProtocol {
    private let maxDefault = 16

    /// Convert level (0–16) to percent (0–100).
    private func levelToPercent(_ level: Int, maxLevel: Int) -> Int {
        return (level * 100 + maxLevel - 1) / maxLevel
    }

    func getCurrentVolume() -> Int {
        let script = NSAppleScript(source: "output volume of (get volume settings)")
        var error: NSDictionary?
        let result = script?.executeAndReturnError(&error)
        guard let percent = result?.int32Value else { return 0 }
        // Convert percent back to level (0-16)
        return Int(percent) * maxDefault / 100
    }

    func setVolume(_ level: Int, maxLevel: Int = 16) {
        let percent = levelToPercent(level, maxLevel: maxLevel)
        let script = NSAppleScript(source: "set volume output volume \(percent)")
        var error: NSDictionary?
        script?.executeAndReturnError(&error)
    }

    /// Only increase volume — never decrease. Matches the bash script behavior.
    func setVolumeIfBelow(_ level: Int, maxLevel: Int = 16) {
        let targetPercent = levelToPercent(level, maxLevel: maxLevel)
        let source = """
        set targetVolume to \(targetPercent)
        set currentVolume to output volume of (get volume settings)
        if currentVolume < targetVolume then
            set volume output volume targetVolume
        end if
        """
        let script = NSAppleScript(source: source)
        var error: NSDictionary?
        script?.executeAndReturnError(&error)
    }
}
