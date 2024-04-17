//
//  ArtistInfo.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 17.04.2024.
//

import Foundation

struct ArtistInfo: Decodable {
    let artistName: String
    let artistLinkUrl: URL
    let primaryGenreName: String?
}
