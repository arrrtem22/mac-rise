//
//  OnboardingView.swift
//  mac-rise
//
//  Root coordinator view for the multi-step onboarding flow.
//

import SwiftUI

struct OnboardingView: View {
    @Bindable var appState: AppState
    @State private var viewModel: OnboardingViewModel

    init(appState: AppState) {
        self.appState = appState
        self._viewModel = State(initialValue: OnboardingViewModel(appState: appState))
    }

    var body: some View {
        ZStack {
            MacRiseBackground()

            Group {
                switch viewModel.currentStep {
                case 0: WelcomeStepView(viewModel: viewModel)
                case 1: MusicSourceStepView(viewModel: viewModel)
                case 2: AlarmTimeStepView(viewModel: viewModel)
                case 3: LockDurationStepView(viewModel: viewModel)
                case 4: VolumeConfigStepView(viewModel: viewModel)
                case 5: ReviewInstallStepView(viewModel: viewModel)
                default: EmptyView()
                }
            }
            .transition(.asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal: .move(edge: .leading).combined(with: .opacity)
            ))
            .id(viewModel.currentStep)
        }
        .frame(width: MacRiseWindow.onboardingWidth,
               height: MacRiseWindow.onboardingHeight)
        // Push content below floating traffic-light buttons (hidden title bar)
        .safeAreaInset(edge: .top, spacing: 0) {
            Color.clear.frame(height: 28)
        }
    }
}

#Preview {
    OnboardingView(appState: AppState())
}
