//
//  StepDots.swift
//  mac-rise
//
//  Step indicator dots used in onboarding navigation.
//

import SwiftUI

struct StepDots: View {
    let total: Int
    let current: Int

    var body: some View {
        HStack(spacing: MacRiseSpacing.sm) {
            ForEach(0..<total, id: \.self) { i in
                Circle()
                    .fill(i == current
                          ? MacRiseColors.textPrimary
                          : MacRiseColors.textPrimary.opacity(0.30))
                    .frame(width: i == current ? 8 : 7,
                           height: i == current ? 8 : 7)
                    .animation(.easeInOut(duration: 0.2), value: current)
            }
        }
    }
}

#Preview {
    StepDots(total: 5, current: 2)
        .padding()
        .background(MacRiseColors.backgroundPrimary)
}
