//
//  AppRouter.swift
//  mac-rise
//
//  Top-level view router that maps AppRoute to the correct feature view.
//  Used within the onboarding Window scene. The menu bar dropdown is
//  handled separately via MenuBarExtra in MacRiseApp.
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
                // Menu bar is now the main interface — show a minimal "setup complete" view
                // that auto-closes or tells the user to use the menu bar.
                SetupCompleteView(appState: appState)

            case .settings:
                SettingsView(appState: appState)

            case .login:
                LoginView(appState: appState)

            case .subscription:
                SubscriptionView(appState: appState)
            }
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.3), value: appState.currentRoute)
    }
}

// MARK: - Setup Complete (shown after onboarding, prompts to use menu bar)

struct SetupCompleteView: View {
    @Bindable var appState: AppState
    @Environment(\.dismissWindow) private var dismissWindow

    var body: some View {
        ZStack {
            MacRiseBackground()

            VStack(spacing: MacRiseSpacing.lg) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 52))
                    .foregroundColor(MacRiseColors.success)

                Text("MacRise is Running")
                    .font(MacRiseTypography.sectionTitle)
                    .foregroundColor(MacRiseColors.textPrimary)

                Text("Click the alarm icon in the menu bar\nto view your alarm status and settings.")
                    .font(MacRiseTypography.body)
                    .foregroundColor(MacRiseColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)

                Text("Next alarm: \(appState.alarmConfiguration.alarmTimeFormatted)")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(MacRiseColors.accentOrange)
                    .padding(.top, 4)

                HStack(spacing: 14) {
                    PillButton(title: "Close Window", style: .outlined) {
                        dismissWindow(id: "onboarding")
                    }

                    PillButton(title: "Re-run Setup", style: .outlined) {
                        appState.resetOnboarding()
                    }
                }
                .padding(.top, MacRiseSpacing.lg)
            }
        }
        .frame(width: MacRiseWindow.onboardingWidth, height: MacRiseWindow.onboardingHeight)
    }
}
