//
//  ArtistOtherWorksRequest.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 15.04.2024.
//

import Foundation

struct ArtistOtherWorksRequest: NetworkRequest {
    typealias Response = ArtistOtherWorksResponse

    // swiftlint:disable:next force_unwrapping
    let baseURL = URL(string: "https://itunes.apple.com")!
    let path: String = "/lookup"
    let httpMethod: HttpMethod = .GET
    let queryItems: [URLQueryItem]
    let cachePolicy: CachePolicy = .noCache

    init(id: Int) {
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "id", value: String(id)),
            URLQueryItem(name: "entity", value: "song,movie"),
            URLQueryItem(name: "limit", value: "5")
        ]
        self.queryItems = queryItems
    }
}
