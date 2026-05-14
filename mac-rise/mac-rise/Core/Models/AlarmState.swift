//
//  AlarmState.swift
//  mac-rise
//
//  Enum representing the current operational state of the alarm.
//

import Foundation

/// The current runtime state of the alarm system.
enum AlarmState: Equatable {
    /// Alarm is scheduled and waiting to trigger.
    case idle

    /// Alarm is actively playing music and enforcing volume.
    case ringing(remainingSeconds: Int)

    /// No alarm is configured / alarm system is off.
    case disabled

    var isRinging: Bool {
        if case .ringing = self { return true }
        return false
    }

    var displayLabel: String {
        switch self {
        case .idle:                        return "Scheduled"
        case .ringing(let remaining):
            let min = remaining / 60
            let sec = remaining % 60
            return String(format: "%d:%02d remaining", min, sec)
        case .disabled:                    return "Off"
        }
    }
}
