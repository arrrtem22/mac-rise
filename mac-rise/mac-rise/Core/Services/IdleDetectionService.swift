//
//  IdleDetectionService.swift
//  mac-rise
//
//  Service for detecting user activity (mouse/keyboard) via IOKit.
//  Scaffold — implementation will replace ioreg shell calls.
//

import Foundation

/// Protocol for system idle time detection.
protocol IdleDetectionServiceProtocol {
    /// Returns the number of seconds since last user input (mouse/keyboard).
    func systemIdleTime() -> TimeInterval
    /// Returns true if user activity was detected within the threshold.
    func isUserActive(threshold: TimeInterval) -> Bool
}

final class IdleDetectionService: IdleDetectionServiceProtocol {
    func systemIdleTime() -> TimeInterval {
        // TODO: Use IOKit HIDIdleTime to get actual idle duration
        return 0
    }

    func isUserActive(threshold: TimeInterval) -> Bool {
        return systemIdleTime() < threshold
    }
}
