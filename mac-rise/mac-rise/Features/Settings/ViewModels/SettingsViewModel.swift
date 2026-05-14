//
//  SettingsViewModel.swift
//  mac-rise
//

import SwiftUI

@Observable
final class SettingsViewModel {
    private let appState: AppState

    var config: AlarmConfiguration {
        get { appState.alarmConfiguration }
        set { appState.alarmConfiguration = newValue }
    }

    init(appState: AppState) {
        self.appState = appState
    }

    func save() {
        appState.saveSettings()
    }
}
