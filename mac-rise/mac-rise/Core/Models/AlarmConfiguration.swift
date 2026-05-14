//
//  AlarmConfiguration.swift
//  mac-rise
//
//  Codable model holding all user-configurable alarm settings.
//

import Foundation

/// A single, persistable struct that holds every configurable alarm parameter.
struct AlarmConfiguration: Codable, Equatable {
    // MARK: - Music
    var musicSource: MusicSource = .defaultLocation
    var customMusicURL: URL? = nil
    var musicDirectory: String = "~/projects/mac-rise/music"
    var trackCount: Int = 40

    // MARK: - Schedule
    var alarmHour: Int = 6
    var alarmMinute: Int = 45
    var autoWake: Bool = true

    // MARK: - Volume
    var startingVolume: Int = 3
    var targetVolume: Int = 16
    var maxVolumeLevel: Int = 16
    var increaseInterval: Int = 15      // seconds
    var volumeCheckSeconds: Double = 0.5

    // MARK: - Lock
    var lockDurationMinutes: Int = 10

    // MARK: - System
    var launchAtLogin: Bool = false

    // MARK: - Computed
    var lockDurationSeconds: Int { lockDurationMinutes * 60 }

    var wakeHour: Int {
        if alarmMinute == 0 {
            return (alarmHour + 23) % 24
        }
        return alarmHour
    }

    var wakeMinute: Int {
        alarmMinute == 0 ? 59 : alarmMinute - 1
    }

    var alarmTimeFormatted: String {
        let ampm = alarmHour < 12 ? "AM" : "PM"
        let h = alarmHour == 0 ? 12 : (alarmHour > 12 ? alarmHour - 12 : alarmHour)
        return String(format: "%d:%02d %@", h, alarmMinute, ampm)
    }

    var wakeTimeFormatted: String {
        let wH = wakeHour
        let wM = wakeMinute
        let ampm = wH < 12 ? "AM" : "PM"
        let h = wH == 0 ? 12 : (wH > 12 ? wH - 12 : wH)
        return String(format: "%d:%02d %@", h, wM, ampm)
    }

    var volumeRampSummary: String {
        let steps = targetVolume - startingVolume
        guard steps > 0 else { return "Volume already at target" }
        let totalSec = steps * increaseInterval
        let min = totalSec / 60
        let sec = totalSec % 60
        if sec == 0 { return "Volume reaches max in ~\(min) min" }
        return "Volume reaches max in ~\(min) min \(sec) sec if no activity detected"
    }
}
