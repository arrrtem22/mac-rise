//
//  LockDurationStepView.swift
//  mac-rise
//

import SwiftUI

struct LockDurationStepView: View {
    @Bindable var viewModel: OnboardingViewModel
    private let options = AppConstants.Lock.durationOptions

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 10) {
                Image(systemName: "lock.fill")
                    .font(MacRiseTypography.iconLarge)
                    .foregroundColor(MacRiseColors.accentOrange)
                    .padding(.top, 44)
                Text("How long should the alarm play?")
                    .font(MacRiseTypography.sectionTitle)
                    .foregroundColor(MacRiseColors.textPrimary)
            }
            .padding(.bottom, MacRiseSpacing.xxl)

            let cols = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
            LazyVGrid(columns: cols, spacing: 14) {
                ForEach(options, id: \.self) { val in
                    let isSel = viewModel.config.lockDurationMinutes == val
                    let label = val < 60 ? "\(val) min" : "1 hour"
                    SelectableCard(title: label, isSelected: isSel) {
                        viewModel.config.lockDurationMinutes = val
                    }
                }
            }
            .padding(.horizontal, MacRiseSpacing.xxxl)

            Spacer().frame(height: MacRiseSpacing.xl)

            // Warning card
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(MacRiseColors.warning)
                        .font(.system(size: 15))
                    Text("During the lock period, the alarm cannot be stopped.")
                        .font(MacRiseTypography.label)
                        .foregroundColor(MacRiseColors.textPrimary)
                }
                Text("Only Force Quit or shutting down the Mac will stop it.")
                    .font(MacRiseTypography.caption)
                    .foregroundColor(MacRiseColors.textTertiary.opacity(1.1))
                    .padding(.leading, 23)
                Divider().background(MacRiseColors.borderSubtle)
                    .padding(.vertical, 2)
                Text("This is intentional. No snooze. Rise.")
                    .font(MacRiseTypography.captionBold)
                    .foregroundColor(MacRiseColors.textTertiary.opacity(1.2))
                    .italic()
            }
            .padding(MacRiseSpacing.lg)
            .background(
                RoundedRectangle(cornerRadius: MacRiseRadius.card)
                    .fill(MacRiseColors.warning.opacity(0.07))
                    .overlay(
                        RoundedRectangle(cornerRadius: MacRiseRadius.card)
                            .strokeBorder(MacRiseColors.warning.opacity(0.25), lineWidth: 1)
                    )
            )
            .padding(.horizontal, MacRiseSpacing.xxxl)

            Spacer()

            OnboardingNavBar(
                step: 2, totalSteps: viewModel.totalSteps,
                onBack: { viewModel.goToStep(2) },
                onNext: { viewModel.goToStep(4) }
            )
        }
    }
}
