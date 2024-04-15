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
    func artistOtherWorks(artistId: Int) async throws -> ArtistOtherWorksResponse
}

final class ItunesServiceImpl: ItunesService {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = NetworkClientImpl()) {
        self.networkClient = networkClient
    }

    func media(query: String, filters: Filters) async throws -> MediaResponse {
        let request = MediaRequest(query: query, filters: filters)
        return try await networkClient.send(request: request)
    }

    func mediaImage(imageURL: URL) async throws -> MediaImageResponse {
        let request = MediaImageRequest(imageURL: imageURL)
        return try await networkClient.send(request: request)
    }

    func artistLookup(artistId: Int) async throws -> ArtistLookupResponse {
        let request = ArtistLookupRequest(id: artistId)
        return try await networkClient.send(request: request)
    }

    func artistOtherWorks(artistId: Int) async throws -> ArtistOtherWorksResponse {
        let request = ArtistOtherWorksRequest(id: artistId)
        return try await networkClient.send(request: request)
    }
}
