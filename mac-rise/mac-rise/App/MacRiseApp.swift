//
//  MacRiseApp.swift
//  mac-rise
//
//  Created by Artemii Oliinyk on 5/13/26.
//
//  Entry point for the MacRise macOS menu bar alarm application.
//  Routes to onboarding or main interface based on persisted app state.
//

import SwiftUI

@main
struct MacRiseApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            AppRouter(appState: appState)
                .preferredColorScheme(.dark)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
}
