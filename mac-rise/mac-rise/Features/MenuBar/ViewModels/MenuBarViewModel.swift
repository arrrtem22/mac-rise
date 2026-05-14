//
//  MenuBarViewModel.swift
//  mac-rise
//
//  ViewModel for the menu bar dropdown panel.
//  Scaffold — will manage alarm state display, track info, and volume monitoring.
//

import SwiftUI

@Observable
final class MenuBarViewModel {
    private let appState: AppState

    var alarmState: AlarmState { appState.alarmState }
    var config: AlarmConfiguration { appState.alarmConfiguration }

    // MARK: - Ringing state properties (scaffolded)
    var currentTrackName: String = "—"
    var trackProgress: Double = 0.0
    var currentVolume: Int = 0
    var nextVolumeIncreaseSeconds: Int = 0
    var isMovementDetected: Bool = false
    var systemIdleSeconds: Int = 0
    var tracksPlayed: Int = 0
    var totalTracks: Int = 0

    init(appState: AppState) {
        self.appState = appState
    }

    // MARK: - Actions (scaffolded)

    func testAlarm() {
        // TODO: Trigger a short test alarm
    }

    func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}
