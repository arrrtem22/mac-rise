//
//  SettingsView.swift
//  mac-rise
//

import SwiftUI

struct SettingsView: View {
    @Bindable var appState: AppState

    var body: some View {
        ZStack {
            MacRiseBackground()

            VStack(spacing: MacRiseSpacing.xl) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 40))
                    .foregroundColor(MacRiseColors.accentOrange)

                Text("Settings")
                    .font(MacRiseTypography.sectionTitle)
                    .foregroundColor(MacRiseColors.textPrimary)

                Text("Settings panel will be implemented here.\nAll alarm parameters will be configurable.")
                    .font(MacRiseTypography.body)
                    .foregroundColor(MacRiseColors.textTertiary)
                    .multilineTextAlignment(.center)

                PillButton(title: "Back to Main", style: .outlined) {
                    appState.navigateTo(.main)
                }
            }
            .padding(MacRiseSpacing.xxxl)
        }
        .frame(width: MacRiseWindow.onboardingWidth, height: MacRiseWindow.onboardingHeight)
    }
}
