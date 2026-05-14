//
//  ReviewInstallStepView.swift
//  mac-rise
//

import SwiftUI

struct ReviewInstallStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    private var musicLabel: String {
        switch viewModel.config.musicSource {
        case .github:          return "GitHub music pack"
        case .chooseFolder:    return "Custom folder"
        case .defaultLocation: return "~/mac-rise/music (\(viewModel.config.trackCount) tracks)"
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 10) {
                Image(systemName: "checkmark.seal.fill")
                    .font(MacRiseTypography.iconLarge)
                    .foregroundColor(MacRiseColors.success)
                    .padding(.top, 44)
                Text("You're all set")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(MacRiseColors.textPrimary)
            }
            .padding(.bottom, 28)

            // Summary card using InfoRow
            VStack(spacing: 0) {
                InfoRow(icon: "music.note", iconColor: MacRiseColors.info,
                        label: "Music", value: musicLabel)
                Divider().background(MacRiseColors.borderSubtle)
                InfoRow(icon: "alarm.fill", iconColor: MacRiseColors.accentOrange,
                        label: "Alarm", value: "\(viewModel.config.alarmTimeFormatted) daily")
                Divider().background(MacRiseColors.borderSubtle)
                InfoRow(icon: "speaker.wave.2.fill", iconColor: MacRiseColors.iconCyan,
                        label: "Volume", value: "\(viewModel.config.startingVolume) → \(viewModel.config.targetVolume), +1 every \(viewModel.config.increaseInterval)s")
                Divider().background(MacRiseColors.borderSubtle)
                InfoRow(icon: "lock.fill", iconColor: MacRiseColors.warning,
                        label: "Lock", value: "\(viewModel.config.lockDurationMinutes) minutes")
                Divider().background(MacRiseColors.borderSubtle)
                InfoRow(icon: "desktopcomputer", iconColor: MacRiseColors.iconGreen,
                        label: "Auto-wake", value: viewModel.config.autoWake ? "Enabled (\(viewModel.config.wakeTimeFormatted))" : "Disabled")
            }
            .background(
                RoundedRectangle(cornerRadius: MacRiseRadius.large)
                    .fill(MacRiseColors.backgroundSecondary)
                    .overlay(
                        RoundedRectangle(cornerRadius: MacRiseRadius.large)
                            .strokeBorder(MacRiseColors.borderSubtle, lineWidth: 1)
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: MacRiseRadius.large))
            .padding(.horizontal, 36)

            Spacer().frame(height: MacRiseSpacing.xl)

            // Install button
            Button(action: { viewModel.completeOnboarding() }) {
                Text("Install & Activate")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(MacRiseColors.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(
                        LinearGradient(
                            colors: [MacRiseColors.gradientStart, MacRiseColors.gradientEnd],
                            startPoint: .leading, endPoint: .trailing
                        )
                    )
                    .cornerRadius(MacRiseRadius.card)
                    .shadow(color: MacRiseColors.gradientStart.opacity(0.40), radius: 14, x: 0, y: 6)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 36)

            Spacer().frame(height: 10)
            Text("You can change these anytime from the menu bar.")
                .font(MacRiseTypography.labelSmall)
                .foregroundColor(MacRiseColors.textDisabled.opacity(1.1))

            Spacer()

            OnboardingNavBar(
                step: 4, totalSteps: viewModel.totalSteps,
                onBack: { viewModel.goToStep(4) },
                onNext: {},
                nextLabel: "Done",
                nextDisabled: true
            )
        }
    }
}
