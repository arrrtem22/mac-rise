//
//  AlarmTimeStepView.swift
//  mac-rise
//
//  Onboarding Step 3: Configure alarm time and auto-wake toggle.
//

import SwiftUI

struct AlarmTimeStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            // Title
            VStack(spacing: 10) {
                Image(systemName: "alarm.fill")
                    .font(MacRiseTypography.iconLarge)
                    .foregroundColor(MacRiseColors.accentOrange)
                    .padding(.top, 44)

                Text("When should MacRise wake you?")
                    .font(MacRiseTypography.sectionTitle)
                    .foregroundColor(MacRiseColors.textPrimary)
            }
            .padding(.bottom, 36)

            // Time display + steppers
            HStack(spacing: 0) {
                TimeUnitStepper(
                    value: Binding(
                        get: { viewModel.config.alarmHour },
                        set: { viewModel.config.alarmHour = $0 }
                    ),
                    range: 0...23,
                    label: "Hour"
                )

                Text(":")
                    .font(MacRiseTypography.heroTime)
                    .foregroundColor(MacRiseColors.textPrimary.opacity(0.80))
                    .padding(.bottom, 8)

                TimeUnitStepper(
                    value: Binding(
                        get: { viewModel.config.alarmMinute },
                        set: { viewModel.config.alarmMinute = $0 }
                    ),
                    range: 0...59,
                    label: "Minute"
                )
            }
            .padding(.horizontal, 60)

            Spacer().frame(height: MacRiseSpacing.xxl)

            // Auto-wake toggle card
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Wake Mac from sleep automatically")
                        .font(MacRiseTypography.cardTitle)
                        .foregroundColor(MacRiseColors.textPrimary)
                    Text("Your Mac will wake 1 minute before the alarm.\nRequires admin permission.")
                        .font(MacRiseTypography.labelSmall)
                        .foregroundColor(MacRiseColors.textTertiary)
                        .lineSpacing(2)
                }
                Spacer()
                Toggle("", isOn: Binding(
                    get: { viewModel.config.autoWake },
                    set: { viewModel.config.autoWake = $0 }
                ))
                .toggleStyle(.switch)
                .scaleEffect(0.85)
            }
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: MacRiseRadius.card)
                    .fill(MacRiseColors.backgroundSecondary)
                    .overlay(
                        RoundedRectangle(cornerRadius: MacRiseRadius.card)
                            .strokeBorder(MacRiseColors.borderSubtle, lineWidth: 1)
                    )
            )
            .padding(.horizontal, 36)

            Spacer()

            OnboardingNavBar(
                step: 1, totalSteps: viewModel.totalSteps,
                onBack: { viewModel.goToStep(1) },
                onNext: { viewModel.goToStep(3) }
            )
        }
    }
}

// MARK: - macOS-compatible time unit stepper

struct TimeUnitStepper: View {
    @Binding var value: Int
    let range: ClosedRange<Int>
    let label: String

    private func increment() {
        value = value < range.upperBound ? value + 1 : range.lowerBound
    }
    private func decrement() {
        value = value > range.lowerBound ? value - 1 : range.upperBound
    }

    var body: some View {
        VStack(spacing: MacRiseSpacing.sm) {
            // Up chevron
            Button(action: increment) {
                Image(systemName: "chevron.up")
                    .font(MacRiseTypography.iconMedium)
                    .foregroundColor(MacRiseColors.textTertiary.opacity(1.3))
                    .frame(width: 52, height: 30)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            // Value display
            Text(String(format: "%02d", value))
                .font(MacRiseTypography.heroTime)
                .foregroundColor(MacRiseColors.textPrimary)
                .frame(width: 120)
                .multilineTextAlignment(.center)

            // Down chevron
            Button(action: decrement) {
                Image(systemName: "chevron.down")
                    .font(MacRiseTypography.iconMedium)
                    .foregroundColor(MacRiseColors.textTertiary.opacity(1.3))
                    .frame(width: 52, height: 30)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            Text(label)
                .font(MacRiseTypography.labelUpper)
                .foregroundColor(MacRiseColors.textDisabled)
                .tracking(1)
                .textCase(.uppercase)
        }
    }
}

#Preview {
    ZStack {
        MacRiseBackground()
        AlarmTimeStepView(viewModel: OnboardingViewModel(appState: AppState()))
    }
    .frame(width: 780, height: 560)
}
