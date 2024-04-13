//
//  MediaService.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 13.04.2024.
//

import Foundation

protocol MediaService: AnyObject {
    func media(query: String, filters: Filters) async throws -> MediaResponse
    func mediaImage(imageURL: URL) async throws -> MediaImageResponse
}

final class MediaServiceImpl: MediaService {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = NetworkClientImpl()) {
        self.networkClient = networkClient
    }

    func media(query: String, filters: Filters) async throws -> MediaResponse {
        let mediaRequest = MediaRequest(query: query, filters: filters)
        return try await networkClient.send(request: mediaRequest)
    }

    func mediaImage(imageURL: URL) async throws -> MediaImageResponse {
        let imageRequest = MediaImageRequest(imageURL: imageURL)
        return try await networkClient.send(request: imageRequest)
    }
}
