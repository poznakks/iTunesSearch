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
    let kind: MediaType
    let artistId, collectionId, trackId: Int
    let artistName, collectionName, trackName: String
    let artistViewUrl, collectionViewUrl, trackViewUrl: URL
    let previewUrl: String
    let artworkUrl30, artworkUrl60, artworkUrl100: URL
    let collectionPrice, trackPrice: Double?
    let releaseDate: Date
    let collectionExplicitness, trackExplicitness: String
    let country, currency, primaryGenreName: String
}

enum MediaType: String, Decodable {
    case movie = "feature-movie"
    case song = "song"
}
