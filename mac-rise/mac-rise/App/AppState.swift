//
//  AppState.swift
//  mac-rise
//
//  Global application state managing top-level navigation and shared context.
//  Uses the modern @Observable macro for granular SwiftUI reactivity.
//

import SwiftUI

/// The possible top-level screens / routes in the app.
enum AppRoute: Equatable {
    case onboarding
    case main          // Menu bar is active, dropdown panel
    case settings
    case login
    case subscription
}

/// Global application state — injected into the environment.
@Observable
final class AppState {
    // MARK: - Navigation
    var currentRoute: AppRoute = .onboarding

    // MARK: - Alarm
    var alarmConfiguration = AlarmConfiguration()
    var alarmState: AlarmState = .idle

    // MARK: - Auth (scaffold for future)
    var isAuthenticated: Bool = false
    var userEmail: String? = nil

    // MARK: - Subscription (scaffold for future)
    var isSubscribed: Bool = false
    var subscriptionTier: String? = nil

    // MARK: - Services
    @ObservationIgnored
    private var settingsService: SettingsServiceProtocol

    // MARK: - Init

    init(settingsService: SettingsServiceProtocol = SettingsService()) {
        self.settingsService = settingsService

        // Load persisted state
        self.alarmConfiguration = settingsService.loadConfiguration()

        // Determine initial route
        if settingsService.hasCompletedOnboarding {
            self.currentRoute = .main
            self.alarmState = .idle
        } else {
            self.currentRoute = .onboarding
            self.alarmState = .idle
        }
    }

    // MARK: - Actions

    func completeOnboarding() {
        settingsService.saveConfiguration(alarmConfiguration)
        settingsService.hasCompletedOnboarding = true
        alarmState = .idle
        currentRoute = .main
    }

    func saveSettings() {
        settingsService.saveConfiguration(alarmConfiguration)
    }

    func resetOnboarding() {
        settingsService.hasCompletedOnboarding = false
        alarmConfiguration = AlarmConfiguration()
        currentRoute = .onboarding
    }

    func navigateTo(_ route: AppRoute) {
        currentRoute = route
    }

    // MARK: - Alarm state transitions

    /// Start the alarm ringing with the lock duration from config
    func startAlarm() {
        alarmState = .ringing(remainingSeconds: alarmConfiguration.lockDurationSeconds)
    }

    /// Stop the alarm (only valid after lock expires)
    func stopAlarm() {
        alarmState = .idle
    }

    /// Simulate ringing for testing (with a short duration)
    func testAlarm() {
        alarmState = .ringing(remainingSeconds: 30)
    }
}
