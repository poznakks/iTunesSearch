//
//  ArtistLookupRequest.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 14.04.2024.
//

import Foundation

struct ArtistLookupRequest: NetworkRequest {
    typealias Response = ArtistLookupResponse

    // swiftlint:disable:next force_unwrapping
    let baseURL = URL(string: "https://itunes.apple.com")!
    let path: String = "/lookup"
    let httpMethod: HttpMethod = .GET
    let queryItems: [URLQueryItem]
    let cachePolicy: CachePolicy = .noCache

    init(id: Int) {
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "id", value: String(id))
        ]
        self.queryItems = queryItems
    }
}
