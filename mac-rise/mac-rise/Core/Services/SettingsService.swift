//
//  SettingsService.swift
//  mac-rise
//
//  Handles persistence of alarm configuration and app state to UserDefaults.
//

import Foundation

/// Protocol for settings persistence, enabling mock injection in tests.
protocol SettingsServiceProtocol {
    func loadConfiguration() -> AlarmConfiguration
    func saveConfiguration(_ config: AlarmConfiguration)
    var hasCompletedOnboarding: Bool { get set }
}

final class SettingsService: SettingsServiceProtocol {
    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    // MARK: - Alarm Configuration

    func loadConfiguration() -> AlarmConfiguration {
        guard let data = defaults.data(forKey: AppConstants.Keys.alarmConfiguration),
              let config = try? decoder.decode(AlarmConfiguration.self, from: data) else {
            return AlarmConfiguration()
        }
        return config
    }

    func saveConfiguration(_ config: AlarmConfiguration) {
        if let data = try? encoder.encode(config) {
            defaults.set(data, forKey: AppConstants.Keys.alarmConfiguration)
        }
    }

    // MARK: - Onboarding

    var hasCompletedOnboarding: Bool {
        get { defaults.bool(forKey: AppConstants.Keys.hasCompletedOnboarding) }
        set { defaults.set(newValue, forKey: AppConstants.Keys.hasCompletedOnboarding) }
    }
}
