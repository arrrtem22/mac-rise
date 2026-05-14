//
//  AlarmEngine.swift
//  mac-rise
//
//  The core alarm engine that orchestrates scheduling, playback, volume ramping,
//  idle detection, and track rotation. This is the complete replacement for
//  wake-alarm.sh. Runs as a singleton attached to AppState.
//

import Foundation
import Combine

@Observable
final class AlarmEngine {
    // MARK: - State
    var currentTrackName: String = "—"
    var currentVolume: Int = 0
    var actualSystemVolume: Int = 0
    var nextVolumeIncreaseIn: Int = 0
    var isMovementDetected: Bool = false
    var systemIdleSeconds: Int = 0
    var tracksPlayed: Int = 0
    var totalTracks: Int = 0
    var remainingSeconds: Int = 0
    var isRunning: Bool = false

    // MARK: - Services
    @ObservationIgnored private let audioService = AudioService()
    @ObservationIgnored private let volumeService = VolumeService()
    @ObservationIgnored private let idleService = IdleDetectionService()
    @ObservationIgnored private let alarmService = AlarmService()
    @ObservationIgnored private let powerAssertionService = PowerAssertionService()

    // MARK: - Internal state
    @ObservationIgnored private var appState: AppState?
    @ObservationIgnored private var tracks: [URL] = []
    @ObservationIgnored private var trackIndex: Int = 0
    @ObservationIgnored private var volumeCheckTimer: Timer?
    @ObservationIgnored private var countdownTimer: Timer?
    @ObservationIgnored private var scheduledAlarmTimer: Timer?
    @ObservationIgnored private var lastVolumeIncreaseTime: Date = Date()
    @ObservationIgnored private var alarmStartTime: Date = Date()
    @ObservationIgnored private let gracePeriodSeconds: TimeInterval = 10

    // MARK: - Setup

    func attach(to appState: AppState) {
        self.appState = appState
        scheduleNextAlarm()
    }

    // MARK: - Scheduling

    func scheduleNextAlarm() {
        scheduledAlarmTimer?.invalidate()
        guard let config = appState?.alarmConfiguration else { return }

        Task {
            do {
                try await alarmService.scheduleAlarm(config: config)
            } catch {
                print("[AlarmEngine] Failed to configure macOS wake: \(error.localizedDescription)")
            }
        }

        let calendar = Calendar.current
        let now = Date()
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.hour = config.alarmHour
        components.minute = config.alarmMinute
        components.second = 0

        guard var alarmDate = calendar.date(from: components) else { return }

        // If the time has already passed today, schedule for tomorrow
        if alarmDate <= now {
            alarmDate = calendar.date(byAdding: .day, value: 1, to: alarmDate)!
        }

        let interval = alarmDate.timeIntervalSince(now)
        print("[AlarmEngine] Next alarm scheduled for \(alarmDate) (in \(Int(interval))s)")

        scheduledAlarmTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
            self?.startAlarm()
        }
    }

    // MARK: - Start Alarm

    func startAlarm() {
        guard let config = appState?.alarmConfiguration else { return }

        // Load tracks
        let musicDir: URL
        if let customURL = config.customMusicURL {
            musicDir = customURL
        } else {
            // Use default music directory relative to the project
            let expandedPath = NSString(string: config.musicDirectory).expandingTildeInPath
            musicDir = URL(fileURLWithPath: expandedPath)
        }

        do {
            tracks = try audioService.loadTracks(from: musicDir)
        } catch {
            // Fallback: try the bundled music directory
            let fallbackDir = URL(fileURLWithPath: NSString(string: "~/projects/mac-rise/music").expandingTildeInPath)
            tracks = (try? audioService.loadTracks(from: fallbackDir)) ?? []
        }

        guard !tracks.isEmpty else {
            print("[AlarmEngine] No tracks found! Cannot start alarm.")
            return
        }

        // Shuffle tracks
        tracks.shuffle()
        totalTracks = tracks.count
        trackIndex = 0
        tracksPlayed = 0

        // Initialize state
        currentVolume = config.startingVolume
        isMovementDetected = false
        remainingSeconds = config.lockDurationSeconds
        isRunning = true
        alarmStartTime = Date()
        lastVolumeIncreaseTime = Date()

        // Set initial volume
        volumeService.setVolume(currentVolume, maxLevel: config.maxVolumeLevel)
        powerAssertionService.begin(reason: "MacRise alarm is ringing")

        // Update AppState
        appState?.alarmState = .ringing(remainingSeconds: remainingSeconds)

        print("[AlarmEngine] Alarm started! \(tracks.count) tracks, lock: \(config.lockDurationMinutes) min")

        // Start playing
        playNextTrack()

        // Start timers
        startVolumeCheckTimer()
        startCountdownTimer()

        // Set up track finished callback
        audioService.onTrackFinished = { [weak self] in
            self?.onTrackEnded()
        }
    }

    // MARK: - Stop Alarm

    func stopAlarm() {
        volumeCheckTimer?.invalidate()
        countdownTimer?.invalidate()
        volumeCheckTimer = nil
        countdownTimer = nil
        audioService.stop()
        powerAssertionService.end()
        isRunning = false
        currentTrackName = "—"
        appState?.alarmState = .idle

        print("[AlarmEngine] Alarm stopped.")

        // Schedule next alarm for tomorrow
        scheduleNextAlarm()
    }

    // MARK: - Test Alarm (short 30s version)

    func testAlarm() {
        guard let config = appState?.alarmConfiguration else { return }

        // Override lock to 30 seconds for test
        var testConfig = config
        testConfig.lockDurationMinutes = 1 // 60 seconds for test
        appState?.alarmConfiguration = testConfig

        startAlarm()

        // Restore original config after starting (the engine already captured the duration)
        appState?.alarmConfiguration = config
    }

    // MARK: - Add Time

    func addTime(minutes: Int) {
        remainingSeconds += minutes * 60
        appState?.alarmState = .ringing(remainingSeconds: remainingSeconds)
    }

    // MARK: - Track Management

    private func playNextTrack() {
        guard !tracks.isEmpty else { return }
        let track = tracks[trackIndex]
        trackIndex = (trackIndex + 1) % tracks.count
        tracksPlayed += 1
        audioService.play(track: track)
        currentTrackName = audioService.currentTrackName ?? track.deletingPathExtension().lastPathComponent

        // Truncate long names
        if currentTrackName.count > 28 {
            currentTrackName = String(currentTrackName.prefix(25)) + "..."
        }
        print("[AlarmEngine] Playing: \(currentTrackName)")
    }

    private func onTrackEnded() {
        guard isRunning, remainingSeconds > 0 else { return }
        print("[AlarmEngine] Track finished, switching to next.")
        playNextTrack()
    }

    // MARK: - Volume Check Timer (runs every 0.5s, replicates update_volume)

    private func startVolumeCheckTimer() {
        guard let config = appState?.alarmConfiguration else { return }

        volumeCheckTimer = Timer.scheduledTimer(withTimeInterval: config.volumeCheckSeconds, repeats: true) { [weak self] _ in
            self?.updateVolume()
        }
    }

    private func updateVolume() {
        guard let config = appState?.alarmConfiguration, isRunning else { return }

        let idleTime = idleService.systemIdleTime()
        systemIdleSeconds = Int(idleTime)

        // Read actual system volume for the UI
        actualSystemVolume = volumeService.getCurrentVolume()

        // Calculate seconds until next volume increase
        let elapsed = Date().timeIntervalSince(lastVolumeIncreaseTime)
        nextVolumeIncreaseIn = max(0, config.increaseInterval - Int(elapsed))

        if !isMovementDetected {
            // Grace period: skip detection for first 10 seconds
            let timeSinceStart = Date().timeIntervalSince(alarmStartTime)
            if timeSinceStart >= gracePeriodSeconds {
                // Check for user activity (idle < 5 seconds means activity)
                if idleTime < 5 {
                    isMovementDetected = true
                    print("[AlarmEngine] Activity detected (idle: \(Int(idleTime))s)! Volume can be lowered to starting level \(config.startingVolume).")
                } else if elapsed >= Double(config.increaseInterval) {
                    // Time to increase volume
                    if currentVolume < config.targetVolume {
                        currentVolume += 1
                        print("[AlarmEngine] No activity (idle: \(Int(idleTime))s). Volume → \(currentVolume)")
                    }
                    lastVolumeIncreaseTime = Date()
                }
            }
        }

        let enforcedMinimum = isMovementDetected ? config.startingVolume : currentVolume
        volumeService.setVolumeIfBelow(enforcedMinimum, maxLevel: config.maxVolumeLevel)
        actualSystemVolume = volumeService.getCurrentVolume()
    }

    // MARK: - Countdown Timer (runs every 1s)

    private func startCountdownTimer() {
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self, self.isRunning else { return }
            self.remainingSeconds -= 1
            self.appState?.alarmState = .ringing(remainingSeconds: max(0, self.remainingSeconds))

            if self.remainingSeconds <= 0 {
                print("[AlarmEngine] Lock duration reached. Stopping alarm.")
                self.stopAlarm()
            }
        }
    }
}
