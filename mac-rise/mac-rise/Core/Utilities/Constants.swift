//
//  Constants.swift
//  mac-rise
//
//  App-wide constants and configuration defaults.
//

import Foundation

enum AppConstants {
    static let appName = "MacRise"
    static let tagline = "No snooze. No escape. Rise."

    // UserDefaults keys
    enum Keys {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let alarmConfiguration     = "alarmConfiguration"
        static let isAuthenticated        = "isAuthenticated"
        static let subscriptionStatus     = "subscriptionStatus"
    }

    // Volume
    enum Volume {
        static let absoluteMin = 0
        static let absoluteMax = 16
        static let startOptions = [1, 3, 5, 8]
        static let targetOptions = [10, 12, 14, 16]
        static let intervalOptions = [15, 30, 45, 60]
    }

    // Lock duration
    enum Lock {
        static let durationOptions = [3, 5, 10, 15, 30, 60] // minutes
    }

    // Music
    enum Music {
        static let supportedFormats = ["mp3", "m4a", "aac", "wav", "aiff", "flac"]
        static let defaultDirectory = "~/mac-rise/music"
        static let githubURL = "https://github.com/arrrtem22/mac-rise-music"
    }
}
