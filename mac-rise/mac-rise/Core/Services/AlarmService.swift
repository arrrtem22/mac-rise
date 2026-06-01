//
//  AlarmService.swift
//  mac-rise
//
//  Service for configuring macOS wake events.
//

import Foundation

/// Protocol for alarm lifecycle management.
protocol AlarmServiceProtocol {
    func scheduleAlarm(config: AlarmConfiguration) async throws
    func cancelAlarm() async throws
    func configurePmsetWake(hour: Int, minute: Int) async throws
    func clearPmsetWakeConfiguration()
    func installLaunchAgent(config: AlarmConfiguration) async throws
    func removeLaunchAgent() async throws
}

final class AlarmService: AlarmServiceProtocol {
    private let defaults: UserDefaults
    private let configuredWakeTimeKey = "macRise.configuredPmsetWakeTime"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func scheduleAlarm(config: AlarmConfiguration) async throws {
        if config.autoWake {
            try await configurePmsetWake(hour: config.wakeHour, minute: config.wakeMinute)
            try await installLaunchAgent(config: config)
        } else {
            clearPmsetWakeConfiguration()
            try await removeLaunchAgent()
        }
    }

    func cancelAlarm() async throws {
        clearPmsetWakeConfiguration()
        try await removeLaunchAgent()
    }

    func configurePmsetWake(hour: Int, minute: Int) async throws {
        let wakeTime = String(format: "%02d:%02d:00", hour, minute)
        let pmsetDisplayTime = Self.pmsetDisplayTime(hour: hour, minute: minute)

        if defaults.string(forKey: configuredWakeTimeKey) == wakeTime,
           currentPmsetSchedule().contains("wakepoweron at \(pmsetDisplayTime)") {
            return
        }

        let scriptSource = """
        do shell script "/usr/bin/pmset repeat wakeorpoweron MTWRFSU \(wakeTime)" with administrator privileges
        """

        try await MainActor.run {
            let script = NSAppleScript(source: scriptSource)
            var error: NSDictionary?
            script?.executeAndReturnError(&error)

            if let error {
                throw AlarmServiceError.pmsetConfigurationFailed(error.description)
            }

            defaults.set(wakeTime, forKey: configuredWakeTimeKey)
            Logger.log("[AlarmService] Configured macOS wake/power-on for \(wakeTime)")
        }
    }

    func clearPmsetWakeConfiguration() {
        defaults.removeObject(forKey: configuredWakeTimeKey)
    }

    func installLaunchAgent(config: AlarmConfiguration) async throws {
        let fileManager = FileManager.default
        guard let libraryDir = fileManager.urls(for: .libraryDirectory, in: .userDomainMask).first else { return }
        let launchAgentsDir = libraryDir.appendingPathComponent("LaunchAgents")
        try? fileManager.createDirectory(at: launchAgentsDir, withIntermediateDirectories: true)
        
        let plistURL = launchAgentsDir.appendingPathComponent("app.macrise.alarm.plist")
        
        let plistString = """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>Label</key>
            <string>app.macrise.alarm</string>
            <key>ProgramArguments</key>
            <array>
                <string>/usr/bin/open</string>
                <string>-g</string>
                <string>-b</string>
                <string>app.macrise.mac-rise</string>
            </array>
            <key>RunAtLoad</key>
            <false/>
            <key>StartCalendarInterval</key>
            <dict>
                <key>Hour</key>
                <integer>\\(config.alarmHour)</integer>
                <key>Minute</key>
                <integer>\\(config.alarmMinute)</integer>
            </dict>
        </dict>
        </plist>
        """
        
        try plistString.write(to: plistURL, atomically: true, encoding: .utf8)
        
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/launchctl")
        process.arguments = ["unload", plistURL.path]
        try? process.run()
        process.waitUntilExit()
        
        let loadProcess = Process()
        loadProcess.executableURL = URL(fileURLWithPath: "/bin/launchctl")
        loadProcess.arguments = ["load", plistURL.path]
        try loadProcess.run()
        loadProcess.waitUntilExit()
        
        Logger.log("[AlarmService] Installed LaunchAgent for \\(config.alarmHour):\\(String(format: "%02d", config.alarmMinute))")
    }

    func removeLaunchAgent() async throws {
        let fileManager = FileManager.default
        guard let libraryDir = fileManager.urls(for: .libraryDirectory, in: .userDomainMask).first else { return }
        let launchAgentsDir = libraryDir.appendingPathComponent("LaunchAgents")
        let plistURL = launchAgentsDir.appendingPathComponent("app.macrise.alarm.plist")
        
        if fileManager.fileExists(atPath: plistURL.path) {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/bin/launchctl")
            process.arguments = ["unload", plistURL.path]
            try? process.run()
            process.waitUntilExit()
            
            try? fileManager.removeItem(at: plistURL)
            Logger.log("[AlarmService] Removed LaunchAgent")
        }
    }

    private func currentPmsetSchedule() -> String {
        let process = Process()
        let pipe = Pipe()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/pmset")
        process.arguments = ["-g", "sched"]
        process.standardOutput = pipe
        process.standardError = pipe

        do {
            try process.run()
            process.waitUntilExit()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            return String(data: data, encoding: .utf8) ?? ""
        } catch {
            return ""
        }
    }

    private static func pmsetDisplayTime(hour: Int, minute: Int) -> String {
        let displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour)
        let suffix = hour < 12 ? "AM" : "PM"
        return String(format: "%d:%02d%@", displayHour, minute, suffix)
    }
}

enum AlarmServiceError: LocalizedError {
    case pmsetConfigurationFailed(String)

    var errorDescription: String? {
        switch self {
        case .pmsetConfigurationFailed(let message):
            return "Failed to configure pmset wake event: \(message)"
        }
    }
}
