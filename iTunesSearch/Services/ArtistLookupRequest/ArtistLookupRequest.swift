//
//  ArtistLookupRequest.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 14.04.2024.
//

import Foundation

struct ArtistLookupRequest: NetworkRequest {
    typealias Response = ArtistLookupResponse

    var baseURL: URL {
        guard let urlString = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String,
              let url = URL(string: urlString)
        else { fatalError("Can't find base URL in info.plist") }
        return url
    }
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
