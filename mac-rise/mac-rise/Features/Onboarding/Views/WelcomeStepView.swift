//
//  WelcomeStepView.swift
//  mac-rise
//
//  Onboarding Step 1: Welcome screen with app icon, headline, and Get Started button.
//

import SwiftUI

struct WelcomeStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // App icon
            ZStack {
                RoundedRectangle(cornerRadius: MacRiseRadius.pill)
                    .fill(
                        LinearGradient(
                            colors: [MacRiseColors.gradientStart, MacRiseColors.gradientEnd],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 90, height: 90)
                    .shadow(color: MacRiseColors.gradientStart.opacity(0.55),
                            radius: 28, x: 0, y: 10)

                Image(systemName: "alarm.fill")
                    .font(.system(size: 44, weight: .semibold))
                    .foregroundColor(MacRiseColors.textPrimary)
            }

            Spacer().frame(height: 36)

            // Headline
            Text("Rise. No excuses.")
                .font(MacRiseTypography.heroTitle)
                .foregroundColor(MacRiseColors.textPrimary)
                .multilineTextAlignment(.center)

            Spacer().frame(height: MacRiseSpacing.lg)

            // Subtext
            Text("MacRise wakes you up with motivational music\nand won't let you go back to sleep.")
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(MacRiseColors.textTertiary.opacity(1.2))
                .multilineTextAlignment(.center)
                .lineSpacing(4)

            Spacer()

            // Get Started button
            PillButton(title: "Get Started", style: .outlined) {
                viewModel.goToStep(1)
            }

            Spacer().frame(height: MacRiseSpacing.xxxl)
        }
        .padding(.horizontal, 60)
    }
}

#Preview {
    ZStack {
        MacRiseBackground()
        WelcomeStepView(viewModel: OnboardingViewModel(appState: AppState()))
    }
    .frame(width: 780, height: 560)
}
