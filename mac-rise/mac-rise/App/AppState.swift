//
//  AppState.swift
//  mac-rise
//
//  Global application state managing top-level navigation and shared context.
//

import SwiftUI

enum AppRoute: Equatable {
    case onboarding
    case main
    case settings
    case login
    case subscription
}

@Observable
final class AppState {
    // MARK: - Navigation
    var currentRoute: AppRoute = .onboarding

    // MARK: - Alarm
    var alarmConfiguration = AlarmConfiguration()
    var alarmState: AlarmState = .idle

    // MARK: - Engine
    let alarmEngine = AlarmEngine()

    // MARK: - Auth (scaffold)
    var isAuthenticated: Bool = false
    var userEmail: String? = nil

    // MARK: - Subscription (scaffold)
    var isSubscribed: Bool = false
    var subscriptionTier: String? = nil

    // MARK: - Services
    @ObservationIgnored
    private var settingsService: SettingsServiceProtocol

    // MARK: - Init

    init(settingsService: SettingsServiceProtocol = SettingsService()) {
        self.settingsService = settingsService
        self.alarmConfiguration = settingsService.loadConfiguration()

        if settingsService.hasCompletedOnboarding {
            self.currentRoute = .main
            self.alarmState = .idle
        } else {
            self.currentRoute = .onboarding
            self.alarmState = .idle
        }

        // Attach engine
        alarmEngine.attach(to: self)
    }

    // MARK: - Actions

    func completeOnboarding() {
        settingsService.saveConfiguration(alarmConfiguration)
        settingsService.hasCompletedOnboarding = true
        alarmState = .idle
        currentRoute = .main
        // Schedule the alarm
        alarmEngine.scheduleNextAlarm()
    }

    func saveSettings() {
        settingsService.saveConfiguration(alarmConfiguration)
        alarmEngine.scheduleNextAlarm()
    }

    func resetOnboarding() {
        settingsService.hasCompletedOnboarding = false
        alarmConfiguration = AlarmConfiguration()
        currentRoute = .onboarding
    }

    func navigateTo(_ route: AppRoute) {
        currentRoute = route
    }
}
