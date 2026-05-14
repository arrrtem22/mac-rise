//
//  MacRiseApp.swift
//  mac-rise
//
//  Created by Artemii Oliinyk on 5/13/26.
//
//  Entry point for the MacRise macOS menu bar alarm application.
//  The app lives entirely in the macOS status bar with no Dock icon.
//  On first launch, an onboarding window is shown.
//

import SwiftUI

@main
struct MacRiseApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        // MARK: - Menu Bar (always present)
        MenuBarExtra {
            MenuBarDropdownView(appState: appState)
        } label: {
            MenuBarIconView(appState: appState)
        }
        .menuBarExtraStyle(.window)

        // MARK: - Onboarding Window (shown on first launch)
        Window("MacRise Setup", id: "onboarding") {
            AppRouter(appState: appState)
                .preferredColorScheme(.dark)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .defaultLaunchBehavior(.presented)
    }
}

// MARK: - Menu Bar Icon View

struct MenuBarIconView: View {
    @Bindable var appState: AppState

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: menuBarIconName)
                .symbolRenderingMode(.hierarchical)

            if case .ringing(let remaining) = appState.alarmState {
                let min = remaining / 60
                let sec = remaining % 60
                Text(String(format: "%d:%02d", min, sec))
                    .font(.system(size: 11, weight: .medium, design: .monospaced))
                    .monospacedDigit()
            }
        }
    }

    private var menuBarIconName: String {
        switch appState.alarmState {
        case .idle:     return "alarm"
        case .ringing:  return "alarm.fill"
        case .disabled: return "alarm"
        }
    }
}
