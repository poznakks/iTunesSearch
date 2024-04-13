//
//  RequestBuilder.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 24.03.2024.
//

import Foundation

protocol RequestBuilder: AnyObject, Sendable {
    func build<Request: NetworkRequest>(request: Request) throws -> URLRequest
}

final class RequestBuilderImpl: RequestBuilder {
    func build<Request: NetworkRequest>(request: Request) throws -> URLRequest {
        let url = request.baseURL
            .appending(path: request.path)
            .appending(queryItems: request.queryItems)

        var request = URLRequest(url: url)
        request.httpMethod = request.httpMethod
        request.timeoutInterval = request.timeoutInterval

        return request
    }
}
