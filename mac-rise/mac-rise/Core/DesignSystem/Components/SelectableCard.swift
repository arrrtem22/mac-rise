//
//  SelectableCard.swift
//  mac-rise
//
//  Reusable selectable card component used in onboarding option grids.
//

import SwiftUI

struct SelectableCard: View {
    let title: String
    var subtitle: String? = nil
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(MacRiseTypography.body)
                        .foregroundColor(MacRiseColors.textPrimary)
                    if let subtitle {
                        Text(subtitle)
                            .font(MacRiseTypography.labelSmall)
                            .foregroundColor(MacRiseColors.textTertiary)
                            .lineLimit(2)
                    }
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(MacRiseColors.accentOrange)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 15)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: MacRiseRadius.card)
                    .fill(Color.white.opacity(isSelected ? 0.12 : 0.06))
                    .overlay(
                        RoundedRectangle(cornerRadius: MacRiseRadius.card)
                            .strokeBorder(
                                isSelected
                                ? MacRiseColors.borderSelected
                                : MacRiseColors.borderSubtle,
                                lineWidth: 1.5
                            )
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 12) {
        SelectableCard(title: "Selected", isSelected: true) {}
        SelectableCard(title: "Not selected", subtitle: "With description", isSelected: false) {}
    }
    .padding()
    .background(MacRiseColors.backgroundPrimary)
}
