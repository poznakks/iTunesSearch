//
//  NetworkRequest.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 24.03.2024.
//

import UIKit

protocol NetworkRequest {
    associatedtype Response

    var host: String { get }
    var path: String { get }
    var httpMethod: HttpMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var cachePolicy: CachePolicy { get }
    var timeoutInterval: TimeInterval { get }
    var responseConverter: NetworkResponseConverterOf<Response> { get }
}

extension NetworkRequest where Response: Decodable {
    var responseConverter: NetworkResponseConverterOf<Response> {
        NetworkResponseConverterOf(converter: DecodableNetworkResponseConverter())
    }
}

extension NetworkRequest where Response == UIImage {
    var responseConverter: NetworkResponseConverterOf<Response> {
        NetworkResponseConverterOf(converter: ImageNetworkResponseConverter())
    }
}
