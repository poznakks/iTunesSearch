//
//  MockNetworkRequest.swift
//  iTunesSearchTests
//
//  Created by Vlad Boguzh on 17.04.2024.
//

import Foundation
@testable import iTunesSearch

struct MockNetworkRequest: NetworkRequest {
    typealias Response = MockNetworkResponse

    let baseURL: URL
    let path: String
    let httpMethod: HttpMethod
    let queryItems: [URLQueryItem]
    let cachePolicy: CachePolicy
    let timeoutInterval: TimeInterval
    let responseConverter: NetworkResponseConverterOf<Response>

    init(
        baseURL: URL,
        path: String,
        httpMethod: HttpMethod,
        queryItems: [URLQueryItem],
        cachePolicy: CachePolicy,
        timeoutInterval: TimeInterval,
        responseConverter: NetworkResponseConverterOf<Response>
    ) {
        self.baseURL = baseURL
        self.path = path
        self.httpMethod = httpMethod
        self.queryItems = queryItems
        self.cachePolicy = cachePolicy
        self.timeoutInterval = timeoutInterval
        self.responseConverter = responseConverter
    }

    init() {
        // swiftlint:disable:next force_unwrapping
        self.baseURL = URL(string: "https://example.com")!
        self.path = "/api"
        self.httpMethod = .GET
        self.queryItems = [URLQueryItem(name: "param", value: "value")]
        self.cachePolicy = .noCache
        self.timeoutInterval = 30
        self.responseConverter = NetworkResponseConverterOf<Response>(
            converter: DecodableNetworkResponseConverter()
        )
    }
}

struct MockNetworkResponse: Decodable, Equatable {
    let resultCount: Int
    let results: [FullName]

    struct FullName: Decodable, Equatable {
        let firstName: String
        let secondName: String
    }
}
