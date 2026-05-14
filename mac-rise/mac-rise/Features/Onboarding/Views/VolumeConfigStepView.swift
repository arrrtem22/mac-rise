//
//  VolumeConfigStepView.swift
//  mac-rise
//

import SwiftUI

struct VolumeConfigStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    private let startOptions = AppConstants.Volume.startOptions
    private let targetOptions = AppConstants.Volume.targetOptions
    private let intervalOptions = AppConstants.Volume.intervalOptions

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 10) {
                Image(systemName: "speaker.wave.3.fill")
                    .font(MacRiseTypography.iconLarge)
                    .foregroundColor(MacRiseColors.accentOrange)
                    .padding(.top, 36)
                Text("Set volume behavior")
                    .font(MacRiseTypography.sectionTitle)
                    .foregroundColor(MacRiseColors.textPrimary)
            }
            .padding(.bottom, MacRiseSpacing.xl)

            HStack(alignment: .top, spacing: MacRiseSpacing.lg) {
                VolumeCard(
                    title: "Starting volume",
                    subtitle: "Volume when alarm begins",
                    warning: "Important: this is the minimum volume during the alarm. After volume increases, you can lower it only back to this level.",
                    options: startOptions,
                    selected: viewModel.config.startingVolume,
                    onSelect: {
                        viewModel.config.startingVolume = $0
                        viewModel.previewVolume(level: $0)
                    }
                )
                VolumeCard(
                    title: "Target volume",
                    subtitle: "Max volume to reach",
                    options: targetOptions,
                    selected: viewModel.config.targetVolume,
                    onSelect: {
                        viewModel.config.targetVolume = $0
                        viewModel.previewVolume(level: $0)
                    }
                )
            }
            .padding(.horizontal, 36)

            Spacer().frame(height: MacRiseSpacing.lg)

            VStack(alignment: .leading, spacing: 10) {
                Text("Increase interval")
                    .font(MacRiseTypography.label)
                    .foregroundColor(MacRiseColors.textSecondary)

                HStack(spacing: 10) {
                    ForEach(intervalOptions, id: \.self) { val in
                        let isSelected = viewModel.config.increaseInterval == val
                        Button(action: { viewModel.config.increaseInterval = val }) {
                            HStack(spacing: 6) {
                                Text("\(val)s")
                                    .font(MacRiseTypography.bodySmall)
                                    .foregroundColor(MacRiseColors.textPrimary)
                                if isSelected {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundColor(MacRiseColors.accentOrange)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .macRiseCard(isSelected: isSelected)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, 36)

            Spacer().frame(height: 14)

            Text(viewModel.config.volumeRampSummary)
                .font(MacRiseTypography.labelSmall)
                .foregroundColor(MacRiseColors.textTertiary)

            Spacer()

            OnboardingNavBar(
                step: 3, totalSteps: viewModel.totalSteps,
                onBack: { viewModel.goToStep(3) },
                onNext: { viewModel.goToStep(5) }
            )
        }
    }
}

struct VolumeCard: View {
    let title: String
    let subtitle: String
    var warning: String? = nil
    let options: [Int]
    let selected: Int
    let onSelect: (Int) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: MacRiseSpacing.md) {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(MacRiseTypography.cardTitle)
                    .foregroundColor(MacRiseColors.textPrimary)
                Text(subtitle)
                    .font(MacRiseTypography.labelSmall)
                    .foregroundColor(MacRiseColors.textTertiary)
                    .lineLimit(2)
                if let warning {
                    Text(warning)
                        .font(MacRiseTypography.labelSmall)
                        .foregroundColor(.red)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 4)
                }
            }

            let cols = [GridItem(.flexible()), GridItem(.flexible())]
            LazyVGrid(columns: cols, spacing: 10) {
                ForEach(options, id: \.self) { val in
                    let isSel = selected == val
                    SelectableCard(title: "\(val)", isSelected: isSel) {
                        onSelect(val)
                    }
                }
            }
        }
        .padding(MacRiseSpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: MacRiseRadius.large)
                .fill(MacRiseColors.backgroundTertiary)
                .overlay(
                    RoundedRectangle(cornerRadius: MacRiseRadius.large)
                        .strokeBorder(MacRiseColors.borderSubtle, lineWidth: 1)
                )
        )
    }
}
