//
//  AudioService.swift
//  mac-rise
//
//  Audio playback using AVFoundation (replaces afplay shell command).
//  Supports MP3, M4A, AAC, WAV, AIFF, FLAC.
//

import Foundation
import AVFoundation

protocol AudioServiceProtocol {
    func loadTracks(from directory: URL) throws -> [URL]
    func play(track: URL)
    func stop()
    var isPlaying: Bool { get }
    var currentTrackName: String? { get }
    var onTrackFinished: (() -> Void)? { get set }
}

final class AudioService: AudioServiceProtocol {
    private var player: AVAudioPlayer?
    private var delegate: AudioPlayerDelegate?
    private(set) var isPlaying: Bool = false
    private(set) var currentTrackName: String? = nil
    var onTrackFinished: (() -> Void)?

    func loadTracks(from directory: URL) throws -> [URL] {
        let fm = FileManager.default
        let contents = try fm.contentsOfDirectory(at: directory,
                                                   includingPropertiesForKeys: nil)
        return contents.filter { url in
            AppConstants.Music.supportedFormats.contains(url.pathExtension.lowercased())
        }
    }

    func play(track: URL) {
        stop()
        do {
            player = try AVAudioPlayer(contentsOf: track)
            delegate = AudioPlayerDelegate { [weak self] in
                self?.isPlaying = false
                self?.onTrackFinished?()
            }
            player?.delegate = delegate
            player?.prepareToPlay()
            player?.play()
            currentTrackName = track.deletingPathExtension().lastPathComponent
            isPlaying = true
        } catch {
            print("[AudioService] Failed to play \(track.lastPathComponent): \(error)")
            isPlaying = false
            currentTrackName = nil
        }
    }

    func stop() {
        player?.stop()
        player = nil
        delegate = nil
        isPlaying = false
        currentTrackName = nil
    }
}

// MARK: - AVAudioPlayerDelegate wrapper

private class AudioPlayerDelegate: NSObject, AVAudioPlayerDelegate {
    let onFinished: () -> Void
    init(onFinished: @escaping () -> Void) { self.onFinished = onFinished }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        onFinished()
    }
}
