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
    func installLaunchAgent() async throws
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
        } else {
            clearPmsetWakeConfiguration()
        }
    }

    func cancelAlarm() async throws {
        clearPmsetWakeConfiguration()
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

    func installLaunchAgent() async throws {
        // The app no longer installs a script-backed LaunchAgent.
    }

    func removeLaunchAgent() async throws {
        // The app no longer installs a script-backed LaunchAgent.
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
