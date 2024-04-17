//
//  Media.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 17.04.2024.
//

import Foundation

struct Media: Decodable, Equatable {
    let wrapperType: WrapperType
    let kind: Kind?
    let collectionType: String?
    let artistType: String?
    let artistId, collectionId, trackId: Int?
    let artistName, collectionName, trackName: String?
    let artistViewUrl, collectionViewUrl, trackViewUrl: URL?
    let artistLinkUrl: URL?
    let artworkUrl100: URL?
    let collectionPrice, trackPrice: Double?
    let trackTimeMillis: Int?
    let country, currency, primaryGenreName: String?
    let longDescription: String?
    let contentAdvisoryRating: String?

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

enum Kind: String, Decodable {
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
