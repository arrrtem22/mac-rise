//
//  AlarmService.swift
//  mac-rise
//
//  Service for scheduling alarms, configuring pmset, and managing LaunchAgent.
//  This is a scaffold — implementations will be added as features are built.
//

import Foundation

/// Protocol for alarm lifecycle management.
protocol AlarmServiceProtocol {
    func scheduleAlarm(config: AlarmConfiguration) async throws
    func cancelAlarm() async throws
    func configurePmsetWake(hour: Int, minute: Int) async throws
    func installLaunchAgent() async throws
    func removeLaunchAgent() async throws
}

final class AlarmService: AlarmServiceProtocol {
    func scheduleAlarm(config: AlarmConfiguration) async throws {
        // TODO: Implement alarm scheduling with Timer / DispatchSource
    }

    func cancelAlarm() async throws {
        // TODO: Cancel running alarm
    }

    func configurePmsetWake(hour: Int, minute: Int) async throws {
        // TODO: Run `pmset repeat wakeorpoweron MTWRFSU HH:MM:00`
    }

    func installLaunchAgent() async throws {
        // TODO: Write and load LaunchAgent plist
    }

    func removeLaunchAgent() async throws {
        // TODO: Unload and remove LaunchAgent plist
    }
}
