//
//  ArtistOtherWorksRequest.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 15.04.2024.
//

import Foundation

struct ArtistOtherWorksRequest: NetworkRequest {
    typealias Response = ArtistOtherWorksResponse

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
            URLQueryItem(name: "id", value: String(id)),
            URLQueryItem(name: "entity", value: "song,movie"),
            URLQueryItem(name: "limit", value: "5")
        ]
        self.queryItems = queryItems
    }
}
