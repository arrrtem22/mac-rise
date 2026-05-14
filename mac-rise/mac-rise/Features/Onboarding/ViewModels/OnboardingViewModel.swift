//
//  OnboardingViewModel.swift
//  mac-rise
//
//  ViewModel for the onboarding flow using the modern @Observable macro.
//  Manages step navigation and delegates configuration to AppState.
//

import SwiftUI

@Observable
final class OnboardingViewModel {
    // MARK: - Navigation
    var currentStep: Int = 0
    let totalSteps: Int = 5

    // MARK: - Reference to global state
    private let appState: AppState

    // MARK: - Convenience accessors to alarm config
    var config: AlarmConfiguration {
        get { appState.alarmConfiguration }
        set { appState.alarmConfiguration = newValue }
    }

    // MARK: - Init

    init(appState: AppState) {
        self.appState = appState
    }

    // MARK: - Navigation Actions

    func goToStep(_ step: Int) {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentStep = step
        }
    }

    func nextStep() {
        goToStep(currentStep + 1)
    }

    func previousStep() {
        goToStep(max(0, currentStep - 1))
    }

    // MARK: - Completion

    func completeOnboarding() {
        appState.completeOnboarding()
    }
}
