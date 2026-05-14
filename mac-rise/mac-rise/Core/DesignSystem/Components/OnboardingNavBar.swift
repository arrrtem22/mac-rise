//
//  OnboardingNavBar.swift
//  mac-rise
//
//  Navigation bar with Back, dots, and Next used at the bottom of onboarding steps.
//

import SwiftUI

struct OnboardingNavBar: View {
    let step: Int
    let totalSteps: Int
    let onBack: () -> Void
    let onNext: () -> Void
    var nextLabel: String = "Next"
    var nextDisabled: Bool = false

    var body: some View {
        HStack {
            PillButton(title: "Back", style: .outlined, action: onBack)

            Spacer()
            StepDots(total: totalSteps, current: step)
            Spacer()

            PillButton(
                title: nextLabel,
                style: .outlined,
                isDisabled: nextDisabled,
                action: onNext
            )
        }
        .padding(.horizontal, 36)
        .padding(.bottom, MacRiseSpacing.xxl)
    }
}

#Preview {
    OnboardingNavBar(step: 2, totalSteps: 5, onBack: {}, onNext: {})
        .background(MacRiseColors.backgroundPrimary)
}
