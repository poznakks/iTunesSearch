//
//  Media.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 06.04.2024.
//

import Foundation

struct MediaResponse: Decodable {
    let resultCount: Int
    let results: [Media]
}

struct Media: Decodable {
    let wrapperType: WrapperType
    let kind: MediaType?
    let collectionType: String?
    let artistType: String?
    let artistId, collectionId, trackId: Int?
    let artistName, collectionName, trackName: String?
    let artistViewUrl, collectionViewUrl, trackViewUrl: URL?
    let previewUrl: String?
    let artworkUrl100: URL?
    let collectionPrice, trackPrice: Double?
    let releaseDate: Date?
    let trackTimeMillis: Int?
    let collectionExplicitness, trackExplicitness: String?
    let country, currency, primaryGenreName: String?

    var trackDurationString: String? {
        guard let trackTimeMillis else { return nil }
        let totalSeconds = trackTimeMillis / 1000
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60

        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}

enum WrapperType: String, Decodable {
    case track
    case collection
    case artist
}

enum MediaType: String, Decodable {
    case movie = "feature-movie"
    case song = "song"

    var toString: String {
        switch self {
        case .movie:
            return "Movie"
        case .song:
            return "Song"
        }
    }
}
