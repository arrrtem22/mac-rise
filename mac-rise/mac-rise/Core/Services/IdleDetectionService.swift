//
//  IdleDetectionService.swift
//  mac-rise
//
//  Detects user activity (mouse/keyboard) via IOKit HIDIdleTime.
//  Replaces the `ioreg -c IOHIDSystem` call from wake-alarm.sh.
//

import Foundation
import IOKit

protocol IdleDetectionServiceProtocol {
    func systemIdleTime() -> TimeInterval
    func isUserActive(threshold: TimeInterval) -> Bool
}

final class IdleDetectionService: IdleDetectionServiceProtocol {
    /// Returns seconds since last user input (mouse/keyboard).
    func systemIdleTime() -> TimeInterval {
        var iterator: io_iterator_t = 0
        let result = IOServiceGetMatchingServices(
            kIOMainPortDefault,
            IOServiceMatching("IOHIDSystem"),
            &iterator
        )
        guard result == KERN_SUCCESS else { return 0 }

        let entry: io_registry_entry_t = IOIteratorNext(iterator)
        defer {
            IOObjectRelease(entry)
            IOObjectRelease(iterator)
        }

        guard entry != 0 else { return 0 }

        var properties: Unmanaged<CFMutableDictionary>?
        guard IORegistryEntryCreateCFProperties(entry, &properties, kCFAllocatorDefault, 0) == KERN_SUCCESS,
              let dict = properties?.takeRetainedValue() as? [String: Any],
              let idleTime = dict["HIDIdleTime"] as? Int64 else {
            return 0
        }

        // HIDIdleTime is in nanoseconds
        return TimeInterval(idleTime) / 1_000_000_000
    }

    func isUserActive(threshold: TimeInterval) -> Bool {
        return systemIdleTime() < threshold
    }
}
