//
//  Theme.swift
//  mac-rise
//
//  Centralized design tokens for the MacRise app.
//

import SwiftUI

// MARK: - Color Palette

enum MacRiseColors {
    // Primary backgrounds
    static let backgroundPrimary   = Color(red: 0.12, green: 0.12, blue: 0.14)
    static let backgroundSecondary = Color(white: 1.0, opacity: 0.06)
    static let backgroundTertiary  = Color(white: 1.0, opacity: 0.05)

    // Accent — warm sunrise palette
    static let accentOrange        = Color(red: 1.0, green: 0.45, blue: 0.15)
    static let accentAmber         = Color(red: 1.0, green: 0.75, blue: 0.20)
    static let accentGold          = Color(red: 0.95, green: 0.84, blue: 0.04)

    // Gradient endpoints for the "Install & Activate" button
    static let gradientStart       = Color(red: 1.0, green: 0.45, blue: 0.15)
    static let gradientEnd         = Color(red: 0.95, green: 0.25, blue: 0.25)

    // Atmospheric background glows
    static let glowPurple          = Color(red: 0.45, green: 0.20, blue: 0.60)
    static let glowAmber           = Color(red: 0.72, green: 0.52, blue: 0.10)

    // Semantic
    static let success             = Color(red: 0.35, green: 0.85, blue: 0.45)
    static let info                = Color(red: 0.55, green: 0.65, blue: 1.0)
    static let warning             = Color(red: 1.0, green: 0.75, blue: 0.20)

    // Text
    static let textPrimary         = Color.white
    static let textSecondary       = Color.white.opacity(0.70)
    static let textTertiary        = Color.white.opacity(0.45)
    static let textDisabled        = Color.white.opacity(0.35)

    // Borders & separators
    static let borderSubtle        = Color.white.opacity(0.10)
    static let borderSelected      = Color(red: 1.0, green: 0.45, blue: 0.15).opacity(0.70)
    static let borderButton        = Color.white.opacity(0.18)

    // Card icon backgrounds (for MusicSourceCard, ReviewRow, etc.)
    static let iconBlue            = Color(red: 0.20, green: 0.60, blue: 1.0)
    static let iconYellow          = Color(red: 1.0, green: 0.75, blue: 0.20)
    static let iconGreen           = Color(red: 0.55, green: 0.85, blue: 0.55)
    static let iconCyan            = Color(red: 0.40, green: 0.80, blue: 1.0)
}

// MARK: - Spacing

enum MacRiseSpacing {
    static let xs: CGFloat  = 4
    static let sm: CGFloat  = 8
    static let md: CGFloat  = 12
    static let lg: CGFloat  = 16
    static let xl: CGFloat  = 24
    static let xxl: CGFloat = 32
    static let xxxl: CGFloat = 48
}

// MARK: - Corner Radii

enum MacRiseRadius {
    static let small: CGFloat  = 8
    static let medium: CGFloat = 10
    static let card: CGFloat   = 14
    static let large: CGFloat  = 16
    static let pill: CGFloat   = 22
    static let button: CGFloat = 24
    static let icon: CGFloat   = 10
}

// MARK: - Window Sizes

enum MacRiseWindow {
    static let onboardingWidth: CGFloat  = 780
    static let onboardingHeight: CGFloat = 560
    static let dropdownWidth: CGFloat    = 320
}
