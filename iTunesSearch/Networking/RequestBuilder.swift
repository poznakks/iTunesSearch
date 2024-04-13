//
//  RequestBuilder.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 24.03.2024.
//

import Foundation

protocol RequestBuilder: AnyObject {
    func build(request: any NetworkRequest) throws -> URLRequest
}

final class RequestBuilderImpl: RequestBuilder {

    func build(request: any NetworkRequest) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = request.host
        components.path = request.path
        components.queryItems = request.queryItems

        guard let url = components.url else {
            print("Failed to create URL")
            throw NetworkError.cantBuildUrlFromRequest
        }

        var request = URLRequest(url: url)
        request.httpMethod = request.httpMethod
        request.timeoutInterval = request.timeoutInterval

        return request
    }
}
