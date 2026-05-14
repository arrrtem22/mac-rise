//
//  MenuBarDropdownView.swift
//  mac-rise
//
//  Root dropdown panel shown when clicking the menu bar icon.
//  Uses native macOS popover material for the LookAway aesthetic.
//

import SwiftUI

struct MenuBarDropdownView: View {
    @Bindable var appState: AppState
    @State private var selectedTab: MenuBarTab = .now

    enum MenuBarTab: String, CaseIterable {
        case now = "Now"
        case stats = "Stats"
    }

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header
            headerView
                .padding(.top, 16)
                .padding(.horizontal, 18)
                .padding(.bottom, 14)

            // MARK: - Content
            if selectedTab == .now {
                switch appState.alarmState {
                case .idle, .disabled:
                    IdleStatusView(appState: appState)
                case .ringing:
                    ActiveStatusView(appState: appState)
                }
            } else {
                StatsPlaceholderView()
            }
        }
        .frame(width: 320)
        .background(
            VisualEffectView(material: .popover, blendingMode: .behindWindow)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Color.white.opacity(0.16), lineWidth: 1)
        )
        .background(MenuBarWindowAppearanceConfigurator())
        .preferredColorScheme(.dark)
    }

    // MARK: - Header

    private var headerView: some View {
        HStack(spacing: 0) {
            // Segmented control — matches LookAway's solid-fill selected tab
            HStack(spacing: 0) {
                ForEach(MenuBarTab.allCases, id: \.self) { tab in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.15)) { selectedTab = tab }
                    }) {
                        Text(tab.rawValue)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(selectedTab == tab ? .black : .white.opacity(0.55))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 7)
                            .background(
                                Capsule()
                                    .fill(selectedTab == tab ? Color.white.opacity(0.85) : Color.clear)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(3)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.08))
            )

            Spacer()

            // Gear icon
            Button(action: { /* TODO: Open settings */ }) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.45))
                    .frame(width: 30, height: 30)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - Stats placeholder

struct StatsPlaceholderView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 24))
                .foregroundColor(.white.opacity(0.25))
            Text("Stats coming soon")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.35))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
    }
}
