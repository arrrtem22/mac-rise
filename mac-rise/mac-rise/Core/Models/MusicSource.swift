//
//  MusicSource.swift
//  mac-rise
//
//  Core data model for alarm music source selection.
//

import Foundation

/// Represents where the alarm music files are sourced from.
enum MusicSource: String, Identifiable, Codable, CaseIterable {
    case github
    case chooseFolder
    case defaultLocation

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .github:          return "GitHub music pack"
        case .chooseFolder:    return "Custom folder"
        case .defaultLocation: return "~/mac-rise/music"
        }
    }
}
