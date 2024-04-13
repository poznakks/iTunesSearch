//
//  DecodableNetworkResponseConverter.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 24.03.2024.
//

import Foundation

final class DecodableNetworkResponseConverter<Response: Decodable>: NetworkResponseConverter {

    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()

    func decodeResponse(from data: Data) throws -> Response {
        try jsonDecoder.decode(Response.self, from: data)
    }
}
