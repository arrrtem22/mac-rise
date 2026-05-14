//
//  VolumeService.swift
//  mac-rise
//
//  Service for controlling macOS system volume via AppleScript / CoreAudio.
//  Scaffold — implementation will replace osascript calls.
//

import Foundation

/// Protocol for system volume control.
protocol VolumeServiceProtocol {
    func getCurrentVolume() -> Int
    func setVolume(_ level: Int)
}

final class VolumeService: VolumeServiceProtocol {
    func getCurrentVolume() -> Int {
        // TODO: Read current system volume via NSAppleScript or CoreAudio
        return 5
    }

    func setVolume(_ level: Int) {
        // TODO: Set system volume (0–16 scale) via NSAppleScript or CoreAudio
    }
}
