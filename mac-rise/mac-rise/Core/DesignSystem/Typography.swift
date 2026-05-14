//
//  Typography.swift
//  mac-rise
//
//  Reusable font definitions for consistent typography.
//

import SwiftUI

enum MacRiseTypography {
    // Headlines
    static let heroTitle   = Font.system(size: 38, weight: .bold)
    static let sectionTitle = Font.system(size: 28, weight: .bold)
    static let cardTitle   = Font.system(size: 15, weight: .semibold)

    // Body
    static let body        = Font.system(size: 15, weight: .medium)
    static let bodySmall   = Font.system(size: 14, weight: .medium)
    static let caption     = Font.system(size: 13, weight: .regular)
    static let captionBold = Font.system(size: 13, weight: .medium)

    // Labels
    static let label       = Font.system(size: 14, weight: .semibold)
    static let labelSmall  = Font.system(size: 12, weight: .regular)
    static let labelUpper  = Font.system(size: 11, weight: .medium)

    // Buttons
    static let button      = Font.system(size: 16, weight: .semibold)
    static let buttonSmall = Font.system(size: 15, weight: .medium)

    // Special
    static let heroTime    = Font.system(size: 64, weight: .bold, design: .monospaced)
    static let iconLarge   = Font.system(size: 30, weight: .semibold)
    static let iconMedium  = Font.system(size: 18, weight: .semibold)
}
