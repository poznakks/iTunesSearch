//
//  RequestBuilder.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 24.03.2024.
//

import Foundation

protocol RequestBuilder: AnyObject, Sendable {
    func build<Request: NetworkRequest>(request: Request) -> URLRequest
}

final class RequestBuilderImpl: RequestBuilder {
    func build<Request: NetworkRequest>(request: Request) -> URLRequest {
        let url = request.baseURL
            .appending(path: request.path)
            .appending(queryItems: request.queryItems)

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue
        urlRequest.timeoutInterval = request.timeoutInterval

        return urlRequest
    }
}
