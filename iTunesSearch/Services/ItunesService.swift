//
//  ItunesService.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 13.04.2024.
//

import Foundation

protocol ItunesService: AnyObject, Sendable {
    func media(query: String, filters: Filters) async throws -> MediaResponse
    func mediaImage(imageURL: URL) async throws -> MediaImageResponse
    func artistLookup(artistId: Int) async throws -> ArtistLookupResponse
}

final class ItunesServiceImpl: ItunesService {

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

    func artistLookup(artistId: Int) async throws -> ArtistLookupResponse {
        let lookupRequest = ArtistLookupRequest(id: artistId)
        return try await networkClient.send(request: lookupRequest)
    }
}
