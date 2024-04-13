//
//  NetworkClient.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 24.03.2024.
//

import Foundation

protocol NetworkClient: AnyObject {
    func send<Request: NetworkRequest>(request: Request) async throws -> Request.Response
}

final class NetworkClientImpl: NetworkClient {

    // MARK: - Properties
    private let urlSession = URLSession(configuration: .default)

    // MARK: - Dependencies
    private let urlCache: URLCache
    private let userDefaults: UserDefaults
    private let requestBuilder: RequestBuilder

    // MARK: - Init
    init(
        urlCache: URLCache = URLCache(),
        userDefaults: UserDefaults = .standard,
        requestBuilder: RequestBuilder = RequestBuilderImpl()
    ) {
        self.urlCache = urlCache
        self.userDefaults = userDefaults
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
        guard let urlString = urlRequest.url?.absoluteString else { return }

        let expirationTimestamp: Double
        switch cachePolicy {
        case .noCache:
            expirationTimestamp = Date.distantPast.timeIntervalSince1970

        case .oneHour:
            expirationTimestamp = Date().timeIntervalSince1970 + cachePolicy.rawValue

        case .unlimited:
            expirationTimestamp = Date.distantFuture.timeIntervalSince1970
        }

        userDefaults.set(
            expirationTimestamp,
            forKey: Key.expirationTimestamp(urlString: urlString)
        )
        urlCache.storeCachedResponse(cachedURLResponse, for: urlRequest)
    }

    private func cachedData(urlRequest: URLRequest) -> Data? {
        guard let urlString = urlRequest.url?.absoluteString,
              let storedData = userDefaults.object(forKey: Key.expirationTimestamp(urlString: urlString)),
              let expirationTimestamp = storedData as? TimeInterval
        else { return nil }

        guard expirationTimestamp > Date.timeIntervalSinceReferenceDate else {
            userDefaults.removeObject(forKey: Key.expirationTimestamp(urlString: urlString))
            return nil
        }

        return urlCache.cachedResponse(for: urlRequest)?.data
    }
}

// MARK: - Key
private enum Key {
    static func expirationTimestamp(urlString: String) -> String {
        "ExpirationTimestamp_\(urlString)"
    }
}
