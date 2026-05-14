//
//  SubscriptionView.swift
//  mac-rise
//

import SwiftUI

struct SubscriptionView: View {
    @Bindable var appState: AppState

    var body: some View {
        ZStack {
            MacRiseBackground()

            VStack(spacing: MacRiseSpacing.xl) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 48))
                    .foregroundColor(MacRiseColors.accentGold)

                Text("MacRise Pro")
                    .font(MacRiseTypography.sectionTitle)
                    .foregroundColor(MacRiseColors.textPrimary)

                Text("Subscription plans will be displayed here.\nStoreKit 2 integration pending.")
                    .font(MacRiseTypography.body)
                    .foregroundColor(MacRiseColors.textTertiary)
                    .multilineTextAlignment(.center)

                PillButton(title: "Back", style: .outlined) {
                    appState.navigateTo(.main)
                }
            }
        }
        .frame(width: MacRiseWindow.onboardingWidth, height: MacRiseWindow.onboardingHeight)
    }
}
