//
//  Entity.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 12.04.2024.
//

import Foundation

protocol SelectableOption: CaseIterable, Hashable {
    var toString: String { get }
}

enum Entity: String, SelectableOption {
    case movie
    case movieArtist
    case track
    case musicArtist
    case album

    var toString: String {
        switch self {
        case .movie:
            return "Movie"
        case .movieArtist:
            return "Movie Artist"
        case .track:
            return "Track"
        case .musicArtist:
            return "Music Artist"
        case .album:
            return "Album"
        }
    }
}
