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

import AppKit

final class Logger {
    static let shared = Logger()
    private let fileURL: URL
    private let queue = DispatchQueue(label: "app.macrise.logger")
    
    private init() {
        let fileManager = FileManager.default
        let libraryDir = fileManager.urls(for: .libraryDirectory, in: .userDomainMask).first!
        let logsDir = libraryDir.appendingPathComponent("Logs/mac-rise")
        
        try? fileManager.createDirectory(at: logsDir, withIntermediateDirectories: true)
        fileURL = logsDir.appendingPathComponent("mac-rise.log")
        
        if !fileManager.fileExists(atPath: fileURL.path) {
            fileManager.createFile(atPath: fileURL.path, contents: nil)
        }
    }
    
    static func log(_ message: String) {
        print(message)
        shared.queue.async {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
            let timestamp = formatter.string(from: Date())
            let logLine = "[\(timestamp)] \(message)\n"
            
            if let data = logLine.data(using: .utf8) {
                if let fileHandle = try? FileHandle(forWritingTo: shared.fileURL) {
                    fileHandle.seekToEndOfFile()
                    fileHandle.write(data)
                    fileHandle.closeFile()
                }
            }
        }
    }
    
    static func openLogsFolder() {
        let fileManager = FileManager.default
        let libraryDir = fileManager.urls(for: .libraryDirectory, in: .userDomainMask).first!
        let logsDir = libraryDir.appendingPathComponent("Logs/mac-rise")
        NSWorkspace.shared.open(logsDir)
    }
}
