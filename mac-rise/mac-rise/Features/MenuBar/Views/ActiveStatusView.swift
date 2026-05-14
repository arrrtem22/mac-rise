//
//  ActiveStatusView.swift
//  mac-rise
//
//  Dropdown panel content when the alarm is actively ringing.
//  All data is live from AlarmEngine.
//

import SwiftUI

struct ActiveStatusView: View {
    @Bindable var appState: AppState

    private var engine: AlarmEngine { appState.alarmEngine }

    private var remainingFormatted: String {
        let m = engine.remainingSeconds / 60
        let s = engine.remainingSeconds % 60
        return String(format: "%d:%02d", m, s)
    }

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Hero countdown
            VStack(spacing: 6) {
                Image(systemName: "bell.and.waves.left.and.right")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(.white.opacity(0.40))
                    .padding(.top, 20)

                Text("Alarm ends in")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.white.opacity(0.45))

                Text(remainingFormatted)
                    .font(.system(size: 52, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .tracking(-1)
                    .monospacedDigit()
                    .padding(.top, 2)
            }
            .padding(.bottom, 14)

            // MARK: - Action buttons
            HStack(spacing: 10) {
                DropdownPillButton(title: "Stop", icon: "lock.fill", isPrimary: true) {
                    engine.stopAlarm()
                }
                DropdownPillButton(title: "+1m", icon: nil, isPrimary: false) {
                    engine.addTime(minutes: 1)
                }
                DropdownPillButton(title: "+5m", icon: nil, isPrimary: false) {
                    engine.addTime(minutes: 5)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 18)

            // MARK: - Info cards
            VStack(spacing: 8) {
                // Now Playing
                DropdownInfoCard(
                    icon: "play.circle.fill",
                    iconColor: MacRiseColors.textSecondary,
                    label: "Now Playing",
                    value: engine.currentTrackName,
                    isSubtitle: true
                )

                // Volume with segmented bar
                VStack(spacing: 8) {
                    HStack(spacing: 10) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(MacRiseColors.iconCyan.opacity(0.14))
                                .frame(width: 30, height: 30)
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.system(size: 13))
                                .foregroundColor(MacRiseColors.iconCyan)
                        }

                        Text("Volume")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)

                        Spacer()

                        Text("Level \(engine.actualSystemVolume)/16")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.55))
                    }

                    VolumeSegmentedBar(
                        currentLevel: engine.actualSystemVolume,
                        maxLevel: 16
                    )
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(Color.white.opacity(0.07), lineWidth: 1)
                        )
                )

                // Bottom row: Next increase + Activity side by side
                HStack(spacing: 8) {
                    CompactInfoTile(
                        icon: "timer",
                        label: "Next increase",
                        value: "in \(engine.nextVolumeIncreaseIn)s"
                    )
                    CompactInfoTile(
                        icon: "figure.walk",
                        label: "Activity",
                        value: engine.isMovementDetected ? "Detected ✓" : "No movement"
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
    }
}

// MARK: - Volume segmented bar

struct VolumeSegmentedBar: View {
    let currentLevel: Int
    let maxLevel: Int

    var body: some View {
        HStack(spacing: 3) {
            ForEach(1...maxLevel, id: \.self) { level in
                RoundedRectangle(cornerRadius: 2)
                    .fill(level <= currentLevel
                          ? MacRiseColors.accentOrange
                          : Color.white.opacity(0.12))
                    .frame(height: 5)
            }
        }
    }
}

// MARK: - Compact info tile

struct CompactInfoTile: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.white.opacity(0.40))

            Text(label)
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(.white.opacity(0.45))

            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Color.white.opacity(0.07), lineWidth: 1)
                )
        )
    }
}
