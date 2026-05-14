//
//  View+Extensions.swift
//  mac-rise
//
//  Shared view modifiers and extensions.
//

import SwiftUI

// MARK: - Conditional modifier

extension View {
    /// Applies a modifier conditionally.
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: - Card background modifier

extension View {
    /// Applies the standard MacRise card background (rounded rect with subtle border).
    func macRiseCard(isSelected: Bool = false) -> some View {
        self
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
}

// MARK: - Section title modifier

extension View {
    /// Standard section title styling (icon + headline).
    func sectionHeader() -> some View {
        self.padding(.bottom, MacRiseSpacing.xl)
    }
}
