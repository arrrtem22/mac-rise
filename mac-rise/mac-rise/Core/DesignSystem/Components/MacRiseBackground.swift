//
//  MacRiseBackground.swift
//  mac-rise
//
//  Animated atmospheric gradient background used across the app.
//

import SwiftUI

struct MacRiseBackground: View {
    var body: some View {
        ZStack {
            MacRiseColors.backgroundPrimary
                .ignoresSafeArea()

            // Purple glow — bottom-left
            RadialGradient(
                gradient: Gradient(colors: [
                    MacRiseColors.glowPurple.opacity(0.55),
                    Color.clear
                ]),
                center: .bottomLeading,
                startRadius: 10,
                endRadius: 380
            )
            .ignoresSafeArea()

            // Amber glow — top-right
            RadialGradient(
                gradient: Gradient(colors: [
                    MacRiseColors.glowAmber.opacity(0.40),
                    Color.clear
                ]),
                center: .topTrailing,
                startRadius: 10,
                endRadius: 400
            )
            .ignoresSafeArea()
        }
    }
}

#Preview {
    MacRiseBackground()
        .frame(width: 400, height: 300)
}
