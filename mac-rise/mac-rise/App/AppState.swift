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
    var alarmState: AlarmState = .disabled

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
        } else {
            self.currentRoute = .onboarding
        }
    }

    // MARK: - Actions

    func completeOnboarding() {
        settingsService.saveConfiguration(alarmConfiguration)
        settingsService.hasCompletedOnboarding = true
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
}
