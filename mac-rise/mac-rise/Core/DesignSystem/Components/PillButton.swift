//
//  PillButton.swift
//  mac-rise
//
//  Reusable pill-shaped button with outlined/filled variants.
//

import SwiftUI

/// Style variants for PillButton.
enum PillButtonStyle {
    case outlined       // Default: subtle border, translucent fill
    case primary        // Gradient fill for primary actions
    case destructive    // Warning-colored
}

struct PillButton: View {
    let title: String
    var style: PillButtonStyle = .outlined
    var isDisabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(MacRiseTypography.button)
                .foregroundColor(foregroundColor)
                .padding(.horizontal, 22)
                .padding(.vertical, 10)
                .background(backgroundView)
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
    }

    // MARK: - Computed appearance

    private var foregroundColor: Color {
        isDisabled ? MacRiseColors.textDisabled : MacRiseColors.textPrimary
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .outlined:
            RoundedRectangle(cornerRadius: MacRiseRadius.pill)
                .fill(isDisabled
                      ? Color.white.opacity(0.06)
                      : Color.white.opacity(0.14))
                .overlay(
                    RoundedRectangle(cornerRadius: MacRiseRadius.pill)
                        .strokeBorder(MacRiseColors.borderButton, lineWidth: 1)
                )

        case .primary:
            LinearGradient(
                colors: [MacRiseColors.gradientStart, MacRiseColors.gradientEnd],
                startPoint: .leading,
                endPoint: .trailing
            )
            .clipShape(RoundedRectangle(cornerRadius: MacRiseRadius.card))
            .shadow(color: MacRiseColors.gradientStart.opacity(0.40), radius: 14, x: 0, y: 6)

        case .destructive:
            RoundedRectangle(cornerRadius: MacRiseRadius.pill)
                .fill(MacRiseColors.warning.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: MacRiseRadius.pill)
                        .strokeBorder(MacRiseColors.warning.opacity(0.35), lineWidth: 1)
                )
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        PillButton(title: "Outlined", style: .outlined) {}
        PillButton(title: "Primary", style: .primary) {}
        PillButton(title: "Disabled", isDisabled: true) {}
    }
    .padding()
    .background(MacRiseColors.backgroundPrimary)
}
