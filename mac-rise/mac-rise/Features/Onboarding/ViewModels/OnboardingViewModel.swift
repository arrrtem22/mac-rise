//
//  OnboardingViewModel.swift
//  mac-rise
//
//  ViewModel for the onboarding flow using the modern @Observable macro.
//  Manages step navigation and delegates configuration to AppState.
//

import SwiftUI

@Observable
final class OnboardingViewModel {
    // MARK: - Navigation
    var currentStep: Int = 0
    let totalSteps: Int = 5

    // MARK: - Reference to global state
    private let appState: AppState
    private let audioService = AudioService()
    private let volumeService = VolumeService()
    private var currentPreviewTrack: URL?

    // MARK: - Convenience accessors to alarm config
    var config: AlarmConfiguration {
        get { appState.alarmConfiguration }
        set { appState.alarmConfiguration = newValue }
    }

    // MARK: - Init

    init(appState: AppState) {
        self.appState = appState
    }

    // MARK: - Navigation Actions

    func goToStep(_ step: Int) {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentStep = step
        }
    }

    func nextStep() {
        goToStep(currentStep + 1)
    }

    func previousStep() {
        goToStep(max(0, currentStep - 1))
    }

    // MARK: - Volume Preview

    func previewVolume(level: Int) {
        volumeService.setVolume(level, maxLevel: config.maxVolumeLevel)

        if audioService.isPlaying { return }

        guard let track = currentPreviewTrack ?? previewTrack() else { return }
        currentPreviewTrack = track
        audioService.play(track: track)
    }

    private func previewTrack() -> URL? {
        let directory: URL
        if let customMusicURL = config.customMusicURL {
            directory = customMusicURL
        } else {
            directory = URL(fileURLWithPath: NSString(string: config.musicDirectory).expandingTildeInPath)
        }

        if let track = try? audioService.loadTracks(from: directory).randomElement() {
            return track
        }

        let fallback = URL(fileURLWithPath: NSString(string: "~/projects/mac-rise/music").expandingTildeInPath)
        return try? audioService.loadTracks(from: fallback).randomElement()
    }

    // MARK: - Completion

    func completeOnboarding() {
        appState.completeOnboarding()
    }
}
