//
//  ArtistLookupResponse.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 14.04.2024.
//

import Foundation

struct ArtistLookupResponse: Decodable {
    let resultCount: Int
    let results: [ArtistInfo]
}

struct ArtistInfo: Decodable {
    let artistName: String
    let artistLinkUrl: URL
    let primaryGenreName: String?
}
