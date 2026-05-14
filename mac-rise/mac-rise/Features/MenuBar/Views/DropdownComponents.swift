//
//  DropdownComponents.swift
//  mac-rise
//
//  Shared UI components used within the menu bar dropdown panel.
//  Includes pill buttons, info cards, and toggle cards.
//

import SwiftUI

// MARK: - Dropdown pill button (like LookAway's "Start break" / "+1m" / "+5m")

struct DropdownPillButton: View {
    let title: String
    var icon: String? = nil
    var isPrimary: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 11, weight: .medium))
                }
                Text(title)
                    .font(.system(size: 13, weight: .medium))
            }
            .foregroundColor(.white.opacity(isPrimary ? 0.90 : 0.70))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isPrimary
                          ? Color.white.opacity(0.14)
                          : Color.white.opacity(0.06))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(Color.white.opacity(isPrimary ? 0.18 : 0.10), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Dropdown info card (single row: icon + label + value)

struct DropdownInfoCard: View {
    let icon: String
    let iconColor: Color
    let label: String
    let value: String
    var isSubtitle: Bool = false

    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(iconColor.opacity(0.14))
                    .frame(width: 30, height: 30)
                Image(systemName: icon)
                    .font(.system(size: 13))
                    .foregroundColor(iconColor)
            }

            if isSubtitle {
                VStack(alignment: .leading, spacing: 2) {
                    Text(label)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.white.opacity(0.45))
                    Text(value)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                }
            } else {
                Text(label)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)

                Spacer()

                Text(value)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white.opacity(0.55))
                    .lineLimit(1)
            }

            if isSubtitle { Spacer() }
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
    }
}

// MARK: - Dropdown info card with progress bar

struct DropdownInfoCardWithBar: View {
    let icon: String
    let iconColor: Color
    let label: String
    let value: String
    let progress: Double

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(iconColor.opacity(0.14))
                        .frame(width: 30, height: 30)
                    Image(systemName: icon)
                        .font(.system(size: 13))
                        .foregroundColor(iconColor)
                }

                Text(label)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)

                Spacer()

                Text(value)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.45))
                    .lineLimit(1)
            }

            // Thin progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white.opacity(0.10))
                        .frame(height: 3)

                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white.opacity(0.45))
                        .frame(width: geo.size.width * min(max(progress, 0), 1), height: 3)
                }
            }
            .frame(height: 3)
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
    }
}

// MARK: - Dropdown info card with toggle

struct DropdownInfoCardToggle: View {
    let icon: String
    let iconColor: Color
    let label: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(iconColor.opacity(0.14))
                    .frame(width: 30, height: 30)
                Image(systemName: icon)
                    .font(.system(size: 13))
                    .foregroundColor(iconColor)
            }

            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)

            Spacer()

            Toggle("", isOn: $isOn)
                .toggleStyle(.switch)
                .scaleEffect(0.75)
                .frame(width: 44)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
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
