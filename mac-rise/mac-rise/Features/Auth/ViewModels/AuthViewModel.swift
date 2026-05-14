//
//  AuthViewModel.swift
//  mac-rise
//

import SwiftUI

@Observable
final class AuthViewModel {
    private let appState: AppState

    var email: String = ""
    var password: String = ""
    var isLoading: Bool = false
    var errorMessage: String? = nil

    init(appState: AppState) {
        self.appState = appState
    }

    func login() async {
        // TODO: Implement authentication logic
        isLoading = true
        // Simulate auth
        appState.isAuthenticated = true
        appState.userEmail = email
        isLoading = false
        appState.navigateTo(.main)
    }

    func logout() {
        appState.isAuthenticated = false
        appState.userEmail = nil
        appState.navigateTo(.login)
    }
}
