//
//  LoginView.swift
//  mac-rise
//

import SwiftUI

struct LoginView: View {
    @Bindable var appState: AppState

    var body: some View {
        ZStack {
            MacRiseBackground()

            VStack(spacing: MacRiseSpacing.xl) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 48))
                    .foregroundColor(MacRiseColors.accentOrange)

                Text("Sign In")
                    .font(MacRiseTypography.sectionTitle)
                    .foregroundColor(MacRiseColors.textPrimary)

                Text("Authentication will be implemented here.")
                    .font(MacRiseTypography.body)
                    .foregroundColor(MacRiseColors.textTertiary)

                PillButton(title: "Back", style: .outlined) {
                    appState.navigateTo(.main)
                }
            }
        }
        .frame(width: MacRiseWindow.onboardingWidth, height: MacRiseWindow.onboardingHeight)
    }
}
