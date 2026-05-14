//
//  MenuBarDropdownView.swift
//  mac-rise
//
//  Root dropdown panel shown when clicking the menu bar icon.
//  Contains a segmented "Now"/"Stats" header, gear icon, and
//  switches between Idle and Ringing content based on alarm state.
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
            // MARK: - Header: Segmented control + gear
            headerView
                .padding(.top, 14)
                .padding(.horizontal, 16)
                .padding(.bottom, 12)

            Divider()
                .background(Color.white.opacity(0.06))

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
        .frame(width: 310)
        .background(Color(red: 0.11, green: 0.11, blue: 0.13))
    }

    // MARK: - Header

    private var headerView: some View {
        HStack(spacing: 0) {
            // Segmented control
            HStack(spacing: 2) {
                ForEach(MenuBarTab.allCases, id: \.self) { tab in
                    Button(action: { withAnimation(.easeInOut(duration: 0.15)) { selectedTab = tab } }) {
                        Text(tab.rawValue)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(selectedTab == tab ? .white : .white.opacity(0.50))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 7)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(selectedTab == tab ? Color.white.opacity(0.12) : Color.clear)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(3)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.06))
            )

            Spacer()

            // Gear icon
            Button(action: { /* TODO: Open settings */ }) {
                Image(systemName: "gearshape")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.white.opacity(0.50))
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
