//
//  AppRouter.swift
//  mac-rise
//
//  Top-level view router that maps AppRoute to the correct feature view.
//

import SwiftUI

struct AppRouter: View {
    @Bindable var appState: AppState

    var body: some View {
        Group {
            switch appState.currentRoute {
            case .onboarding:
                OnboardingView(appState: appState)

            case .main:
                // TODO: Replace with actual MenuBarPanel once implemented
                MainPlaceholderView(appState: appState)

            case .settings:
                // TODO: Replace with actual SettingsView once implemented
                SettingsView(appState: appState)

            case .login:
                // TODO: Replace with actual LoginView once implemented
                LoginView(appState: appState)

            case .subscription:
                // TODO: Replace with actual SubscriptionView once implemented
                SubscriptionView(appState: appState)
            }
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.3), value: appState.currentRoute)
    }
}

// MARK: - Temporary main placeholder (until MenuBar feature is built)

struct MainPlaceholderView: View {
    @Bindable var appState: AppState

    var body: some View {
        ZStack {
            MacRiseBackground()

            VStack(spacing: MacRiseSpacing.lg) {
                Image(systemName: "alarm.fill")
                    .font(.system(size: 48))
                    .foregroundColor(MacRiseColors.accentOrange)

                Text("MacRise is Active")
                    .font(MacRiseTypography.sectionTitle)
                    .foregroundColor(MacRiseColors.textPrimary)

                Text("Next alarm: \(appState.alarmConfiguration.alarmTimeFormatted)")
                    .font(MacRiseTypography.body)
                    .foregroundColor(MacRiseColors.textSecondary)

                VStack(spacing: MacRiseSpacing.md) {
                    PillButton(title: "Open Settings", style: .outlined) {
                        appState.navigateTo(.settings)
                    }

                    PillButton(title: "Re-run Onboarding", style: .outlined) {
                        appState.resetOnboarding()
                    }
                }
                .padding(.top, MacRiseSpacing.lg)
            }
        }
        .frame(width: MacRiseWindow.onboardingWidth, height: MacRiseWindow.onboardingHeight)
    }
}
