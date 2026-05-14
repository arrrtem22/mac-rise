//
//  IdleStatusView.swift
//  mac-rise
//
//  Dropdown panel content when alarm is scheduled but not ringing.
//  Shows: hero time, action buttons, info cards, footer.
//  Design follows LookAway's idle state layout.
//

import SwiftUI

struct IdleStatusView: View {
    @Bindable var appState: AppState

    private var config: AlarmConfiguration { appState.alarmConfiguration }

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Hero section
            VStack(spacing: 6) {
                Image(systemName: "alarm")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(.white.opacity(0.40))
                    .padding(.top, 20)

                Text("Next alarm")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.white.opacity(0.45))

                Text(config.alarmTimeFormatted)
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .tracking(-1)
                    .padding(.top, 2)
            }
            .padding(.bottom, 14)

            // MARK: - Action buttons
            HStack(spacing: 10) {
                DropdownPillButton(title: "Edit", icon: nil, isPrimary: false) {
                    // TODO: Open settings/edit alarm
                }
                DropdownPillButton(title: "Skip", icon: "forward.end.fill", isPrimary: false) {
                    // TODO: Skip next alarm
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 18)

            // MARK: - Info cards
            VStack(spacing: 8) {
                DropdownInfoCard(
                    icon: "music.note",
                    iconColor: MacRiseColors.info,
                    label: "Music",
                    value: musicDisplayValue
                )

                DropdownInfoCard(
                    icon: "lock.fill",
                    iconColor: MacRiseColors.accentOrange,
                    label: "Lock duration",
                    value: "\(config.lockDurationMinutes) minutes"
                )

                DropdownInfoCardWithBar(
                    icon: "speaker.wave.2.fill",
                    iconColor: MacRiseColors.iconCyan,
                    label: "Volume",
                    value: "\(config.startingVolume) → \(config.targetVolume) (+1 every \(config.increaseInterval)s)",
                    progress: Double(config.startingVolume) / Double(config.maxVolumeLevel)
                )

                DropdownInfoCardToggle(
                    icon: "sun.max.fill",
                    iconColor: MacRiseColors.success,
                    label: "Auto-wake",
                    isOn: Binding(
                        get: { config.autoWake },
                        set: { appState.alarmConfiguration.autoWake = $0 }
                    )
                )
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)

            // MARK: - Footer
            VStack(spacing: 8) {
                // Test Alarm button
                Button(action: { /* TODO: Trigger test alarm */ }) {
                    HStack(spacing: 6) {
                        Image(systemName: "alarm.waves.left.and.right")
                            .font(.system(size: 13, weight: .medium))
                        Text("Test Alarm")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 11)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.08))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(Color.white.opacity(0.10), lineWidth: 1)
                            )
                    )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 16)

                // Quit link
                Button(action: { NSApplication.shared.terminate(nil) }) {
                    Text("Quit MacRise")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.white.opacity(0.35))
                }
                .buttonStyle(.plain)
                .padding(.bottom, 14)
            }
        }
    }

    private var musicDisplayValue: String {
        let dir = config.musicDirectory
        let short = dir.count > 18 ? "~/mac-rise/m..." : dir
        return "\(short)"
    }
}
