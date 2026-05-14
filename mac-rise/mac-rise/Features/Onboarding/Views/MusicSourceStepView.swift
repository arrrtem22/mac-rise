//
//  MusicSourceStepView.swift
//  mac-rise
//
//  Onboarding Step 2: Choose alarm music source.
//

import SwiftUI

struct MusicSourceStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            // Title area
            VStack(spacing: 10) {
                Image(systemName: "music.note.list")
                    .font(MacRiseTypography.iconLarge)
                    .foregroundColor(MacRiseColors.accentOrange)
                    .padding(.top, 44)

                Text("Choose your alarm music")
                    .font(MacRiseTypography.sectionTitle)
                    .foregroundColor(MacRiseColors.textPrimary)

                Text("Supported formats: MP3, M4A, AAC, WAV, AIFF, FLAC")
                    .font(MacRiseTypography.caption)
                    .foregroundColor(MacRiseColors.textTertiary)
            }
            .padding(.bottom, 28)

            // Source cards
            VStack(spacing: MacRiseSpacing.md) {
                MusicSourceCard(
                    selected: viewModel.config.musicSource == .github,
                    icon: "arrow.down.circle.fill",
                    iconColor: MacRiseColors.iconBlue,
                    title: "Download from GitHub",
                    subtitle: "Get the default motivational music pack\ngithub.com/arrrtem22/mac-rise-music"
                ) { viewModel.config.musicSource = .github }

                MusicSourceCard(
                    selected: viewModel.config.musicSource == .chooseFolder,
                    icon: "folder.fill",
                    iconColor: MacRiseColors.iconYellow,
                    title: "Choose a folder",
                    subtitle: "Select any folder with MP3, M4A, AAC, WAV, AIFF, or FLAC files"
                ) { viewModel.config.musicSource = .chooseFolder }

                MusicSourceCard(
                    selected: viewModel.config.musicSource == .defaultLocation,
                    icon: "internaldrive.fill",
                    iconColor: MacRiseColors.iconGreen,
                    title: "Use default location",
                    subtitle: "Place files in ~/mac-rise/music/"
                ) { viewModel.config.musicSource = .defaultLocation }
            }
            .padding(.horizontal, 36)

            // Track count validation
            HStack(spacing: 6) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(MacRiseColors.success)
                    .font(.system(size: 14))
                Text("\(viewModel.config.trackCount) tracks found")
                    .font(MacRiseTypography.captionBold)
                    .foregroundColor(MacRiseColors.success)
            }
            .padding(.top, 14)

            Spacer()

            OnboardingNavBar(
                step: 0, totalSteps: viewModel.totalSteps,
                onBack: { viewModel.goToStep(0) },
                onNext: { viewModel.goToStep(2) }
            )
        }
    }
}

// MARK: - Music source card (feature-specific component)

struct MusicSourceCard: View {
    let selected: Bool
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: MacRiseRadius.icon)
                        .fill(iconColor.opacity(0.18))
                        .frame(width: 40, height: 40)
                    Image(systemName: icon)
                        .foregroundColor(iconColor)
                        .font(MacRiseTypography.iconMedium)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(MacRiseTypography.cardTitle)
                        .foregroundColor(MacRiseColors.textPrimary)
                    Text(subtitle)
                        .font(MacRiseTypography.labelSmall)
                        .foregroundColor(MacRiseColors.textTertiary.opacity(1.1))
                        .lineLimit(2)
                }

                Spacer()

                if selected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(MacRiseColors.accentOrange)
                }
            }
            .padding(MacRiseSpacing.lg)
            .macRiseCard(isSelected: selected)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack {
        MacRiseBackground()
        MusicSourceStepView(viewModel: OnboardingViewModel(appState: AppState()))
    }
    .frame(width: 780, height: 560)
}
