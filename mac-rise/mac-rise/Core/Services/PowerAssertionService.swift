//
//  PowerAssertionService.swift
//  mac-rise
//
//  Keeps macOS awake while the alarm is ringing.
//

import Foundation
import IOKit.pwr_mgt

final class PowerAssertionService {
    private var assertionIDs: [IOPMAssertionID] = []

    func begin(reason: String) {
        guard assertionIDs.isEmpty else { return }

        createAssertion(type: kIOPMAssertionTypePreventUserIdleSystemSleep as String, reason: reason)
        createAssertion(type: kIOPMAssertionTypePreventUserIdleDisplaySleep as String, reason: reason)
    }

    func end() {
        for assertionID in assertionIDs {
            IOPMAssertionRelease(assertionID)
        }
        assertionIDs.removeAll()
    }

    private func createAssertion(type: String, reason: String) {
        var assertionID = IOPMAssertionID(0)
        let result = IOPMAssertionCreateWithName(
            type as CFString,
            IOPMAssertionLevel(kIOPMAssertionLevelOn),
            reason as CFString,
            &assertionID
        )

        if result == kIOReturnSuccess {
            assertionIDs.append(assertionID)
        } else {
            print("[PowerAssertionService] Failed to create \(type) assertion: \(result)")
        }
    }
}
