//
//  MenuBarViewModel.swift
//  mac-rise
//
//  ViewModel for the menu bar dropdown panel.
//  Manages alarm state display, track info, volume monitoring, and user actions.
//

import SwiftUI

@Observable
final class MenuBarViewModel {
    @ObservationIgnored
    private var appState: AppState

    var alarmState: AlarmState { appState.alarmState }
    var config: AlarmConfiguration {
        get { appState.alarmConfiguration }
        set { appState.alarmConfiguration = newValue }
    }

    // MARK: - Ringing state properties
    var currentTrackName: String = "—"
    var trackProgress: Double = 0.0
    var currentVolume: Int = 3
    var nextVolumeIncreaseSeconds: Int = 30
    var isMovementDetected: Bool = false
    var systemIdleSeconds: Int = 0
    var tracksPlayed: Int = 0
    var totalTracks: Int = 40

    init(appState: AppState) {
        self.appState = appState
    }

    // MARK: - Actions

    func testAlarm() {
        appState.testAlarm()
    }

    func stopAlarm() {
        appState.stopAlarm()
    }

    func addTime(minutes: Int) {
        if case .ringing(let remaining) = appState.alarmState {
            appState.alarmState = .ringing(remainingSeconds: remaining + (minutes * 60))
        }
    }

    func quitApp() {
        NSApplication.shared.terminate(nil)
    }

    func saveSettings() {
        appState.saveSettings()
    }
}
