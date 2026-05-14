//
//  SubscriptionViewModel.swift
//  mac-rise
//

import SwiftUI

@Observable
final class SubscriptionViewModel {
    private let appState: AppState

    var isLoading: Bool = false
    var plans: [String] = ["Monthly", "Yearly"]

    init(appState: AppState) {
        self.appState = appState
    }

    func purchase(plan: String) async {
        // TODO: Implement StoreKit 2 purchase flow
        isLoading = true
        appState.isSubscribed = true
        appState.subscriptionTier = plan
        isLoading = false
        appState.navigateTo(.main)
    }

    func restore() async {
        // TODO: Implement restore purchases
    }
}
