//
//  ActiveStatusView.swift
//  mac-rise
//
//  Dropdown panel content when the alarm is actively ringing.
//  Shows: hero countdown, stop/extend buttons, now playing,
//  volume level with segmented bar, next increase, activity status.
//  Design follows LookAway's active break state + screen_2.png reference.
//

import SwiftUI

struct ActiveStatusView: View {
    @Bindable var appState: AppState

    // For demo purposes — these will come from the ViewModel in production
    private var remainingSeconds: Int {
        if case .ringing(let s) = appState.alarmState { return s }
        return 0
    }

    private var remainingFormatted: String {
        let m = remainingSeconds / 60
        let s = remainingSeconds % 60
        return String(format: "%d:%02d", m, s)
    }

    // Demo/scaffold values
    @State private var currentVolume: Int = 5
    @State private var nextIncreaseIn: Int = 18
    @State private var isMovementDetected: Bool = false
    @State private var currentTrack: String = "David Goggins"

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
                    // TODO: Stop alarm (only after lock expires)
                }
                DropdownPillButton(title: "+1m", icon: nil, isPrimary: false) {
                    // TODO: Add 1 minute
                }
                DropdownPillButton(title: "+5m", icon: nil, isPrimary: false) {
                    // TODO: Add 5 minutes
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
                    value: currentTrack,
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

                        Text("Level \(currentVolume)/16")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.55))
                    }

                    // Segmented volume bar
                    VolumeSegmentedBar(
                        currentLevel: currentVolume,
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
                        value: "in \(nextIncreaseIn)s"
                    )
                    CompactInfoTile(
                        icon: "figure.walk",
                        label: "Activity",
                        value: isMovementDetected ? "Movement!" : "No movement"
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

// MARK: - Compact info tile (for side-by-side layout)

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
