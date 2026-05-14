//
//  MenuBarViewModel.swift
//  mac-rise
//
//  ViewModel for the menu bar dropdown panel.
//  Delegates all actions to the AlarmEngine via AppState.
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
    var engine: AlarmEngine { appState.alarmEngine }

    init(appState: AppState) {
        self.appState = appState
    }

    // MARK: - Actions

    func testAlarm() {
        engine.startAlarm()
    }

    func stopAlarm() {
        engine.stopAlarm()
    }

    func addTime(minutes: Int) {
        engine.addTime(minutes: minutes)
    }

    func saveSettings() {
        appState.saveSettings()
    }
}
