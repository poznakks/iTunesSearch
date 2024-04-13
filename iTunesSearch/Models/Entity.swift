//
//  Entity.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 12.04.2024.
//

import Foundation

enum Entity: String, SelectableOption {
    case movie
    case movieArtist
    case song
    case musicArtist
    case album

    var toString: String {
        switch self {
        case .movie:
            return "Movie"
        case .movieArtist:
            return "Movie Artist"
        case .song:
            return "Song"
        case .musicArtist:
            return "Music Artist"
        case .album:
            return "Album"
        }
    }
}
