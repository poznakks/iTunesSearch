//
//  MediaRequest.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 13.04.2024.
//

import Foundation

struct MediaRequest: NetworkRequest {
    typealias Response = MediaResponse

    // swiftlint:disable:next force_unwrapping
    let baseURL = URL(string: "https://itunes.apple.com")!
    let path: String = "/search"
    let httpMethod: HttpMethod = .GET
    let queryItems: [URLQueryItem]
    let cachePolicy: CachePolicy = .noCache

    init(query: String, filters: Filters) {
        let entity = filters.entities.map { $0.rawValue }.joined(separator: ",")
        let explicit = filters.includeExplicit ? "Yes" : "No"
        let country = filters.country.rawValue
        let limit = String(filters.limit)
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "term", value: query),
            URLQueryItem(name: "entity", value: entity),
            URLQueryItem(name: "explicit", value: explicit),
            URLQueryItem(name: "country", value: country),
            URLQueryItem(name: "limit", value: limit)
        ]
        self.queryItems = queryItems
    }
}
