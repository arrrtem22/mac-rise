//
//  MenuBarPanel.swift
//  mac-rise
//
//  Main dropdown panel view shown when clicking the menu bar icon.
//  Scaffold — placeholder for the full Status/Settings tabbed interface.
//

import SwiftUI

struct MenuBarPanel: View {
    @Bindable var appState: AppState

    var body: some View {
        VStack(spacing: MacRiseSpacing.lg) {
            Text("MacRise")
                .font(MacRiseTypography.caption)
                .foregroundColor(MacRiseColors.textTertiary)

            Text("Menu Bar Panel")
                .font(MacRiseTypography.sectionTitle)
                .foregroundColor(MacRiseColors.textPrimary)

            Text("Coming soon — this will show alarm status, controls, and real-time info.")
                .font(MacRiseTypography.labelSmall)
                .foregroundColor(MacRiseColors.textTertiary)
                .multilineTextAlignment(.center)
        }
        .padding(MacRiseSpacing.xl)
        .frame(width: MacRiseWindow.dropdownWidth)
    }
}
