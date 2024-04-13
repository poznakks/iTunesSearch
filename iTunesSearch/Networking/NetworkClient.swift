//
//  NetworkClient.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 24.03.2024.
//

import Foundation

protocol NetworkClient: AnyObject, Sendable {
    func send<Request: NetworkRequest>(request: Request) async throws -> Request.Response
}

final class NetworkClientImpl: NetworkClient {

    // MARK: - Properties
    private let urlSession = URLSession(configuration: .default)

    // MARK: - Dependencies
    private let inMemoryCache: URLCache
    private let requestBuilder: RequestBuilder

    // MARK: - Init
    init(
        inMemoryCache: URLCache = URLCache(
            memoryCapacity: 100 * 1024 * 1024, // 100 MB
            diskCapacity: 0
        ),
        requestBuilder: RequestBuilder = RequestBuilderImpl()
    ) {
        self.inMemoryCache = inMemoryCache
        self.requestBuilder = requestBuilder
    }

    // MARK: - NetworkClient
    func send<Request: NetworkRequest>(request: Request) async throws -> Request.Response {
        let urlRequest = try requestBuilder.build(request: request)
        return try await send(
            urlRequest: urlRequest,
            cachePolicy: request.cachePolicy,
            responseConverter: request.responseConverter
        )
    }

    // MARK: - Private methods - Send methods
    private func send<Converter: NetworkResponseConverter>(
        urlRequest: URLRequest,
        cachePolicy: CachePolicy,
        responseConverter: Converter
    ) async throws -> Converter.Response {
        if let cachedData = cachedData(urlRequest: urlRequest) {
            return try responseConverter.decodeResponse(from: cachedData)
        }

        do {
            let (data, response) = try await urlSession.data(for: urlRequest)

            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode)
            else { throw NetworkError.badResponse }

            cacheDataIfNeeded(
                urlRequest: urlRequest,
                cachePolicy: cachePolicy,
                cachedURLResponse: CachedURLResponse(response: response, data: data)
            )

            return try responseConverter.decodeResponse(from: data)
        } catch {
            switch (error as? URLError)?.code {
            case .some(.notConnectedToInternet):
                throw NetworkError.noInternetConnection

            case .some(.timedOut):
                throw NetworkError.timeout

            default:
                throw error
            }
        }
    }

    // MARK: - Private methods - Cache methods
    private func cacheDataIfNeeded(
        urlRequest: URLRequest,
        cachePolicy: CachePolicy,
        cachedURLResponse: CachedURLResponse
    ) {
        switch cachePolicy {
        case .noCache:
            break

        case .inMemory(let cacheTime):
            switch cacheTime {
            case .unlimited:
                inMemoryCache.storeCachedResponse(cachedURLResponse, for: urlRequest)
            }
        }
    }

    private func cachedData(urlRequest: URLRequest) -> Data? {
        inMemoryCache.cachedResponse(for: urlRequest)?.data
    }
}
