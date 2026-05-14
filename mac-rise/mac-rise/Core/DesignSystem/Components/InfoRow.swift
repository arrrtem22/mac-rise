//
//  InfoRow.swift
//  mac-rise
//
//  Reusable icon + label + value row used in settings, review, and dropdown panels.
//

import SwiftUI

struct InfoRow: View {
    let icon: String
    let iconColor: Color
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: MacRiseRadius.small)
                    .fill(iconColor.opacity(0.16))
                    .frame(width: 34, height: 34)
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .font(.system(size: 15))
            }

            Text(label)
                .font(MacRiseTypography.bodySmall)
                .foregroundColor(MacRiseColors.textSecondary)

            Spacer()

            Text(value)
                .font(MacRiseTypography.label)
                .foregroundColor(MacRiseColors.textPrimary)
                .multilineTextAlignment(.trailing)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 13)
    }
}

#Preview {
    VStack(spacing: 0) {
        InfoRow(icon: "music.note", iconColor: MacRiseColors.info, label: "Music", value: "40 tracks")
        Divider().background(MacRiseColors.borderSubtle)
        InfoRow(icon: "alarm.fill", iconColor: MacRiseColors.accentOrange, label: "Alarm", value: "06:45 AM")
    }
    .background(MacRiseColors.backgroundSecondary)
    .clipShape(RoundedRectangle(cornerRadius: MacRiseRadius.large))
    .padding()
    .background(MacRiseColors.backgroundPrimary)
}
