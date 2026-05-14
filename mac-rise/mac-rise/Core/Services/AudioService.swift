//
//  AudioService.swift
//  mac-rise
//
//  Service for playing audio files (replacement for afplay shell command).
//  Scaffold — implementation will use AVFoundation.
//

import Foundation

/// Protocol for audio playback management.
protocol AudioServiceProtocol {
    func loadTracks(from directory: URL) throws -> [URL]
    func play(track: URL) async throws
    func stop()
    var isPlaying: Bool { get }
    var currentTrackName: String? { get }
}

final class AudioService: AudioServiceProtocol {
    private(set) var isPlaying: Bool = false
    private(set) var currentTrackName: String? = nil

    func loadTracks(from directory: URL) throws -> [URL] {
        let fm = FileManager.default
        let contents = try fm.contentsOfDirectory(at: directory,
                                                   includingPropertiesForKeys: nil)
        return contents.filter { url in
            AppConstants.Music.supportedFormats.contains(url.pathExtension.lowercased())
        }
    }

    func play(track: URL) async throws {
        // TODO: Implement AVAudioPlayer / AVFoundation playback
        currentTrackName = track.lastPathComponent
        isPlaying = true
    }

    func stop() {
        // TODO: Stop playback
        isPlaying = false
        currentTrackName = nil
    }
}
