//
//  NetworkResponseConverterOf.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 24.03.2024.
//

import Foundation

final class NetworkResponseConverterOf<Response>: NetworkResponseConverter {

    private let decodeResponse: (Data) throws -> Response

    init<Converter: NetworkResponseConverter>(
        converter: Converter
    ) where Converter.Response == Response {
        decodeResponse = { data in
            try converter.decodeResponse(from: data)
        }
    }

    func decodeResponse(from data: Data) throws -> Response {
        do {
            return try decodeResponse(data)
        } catch {
            print(error)
            throw NetworkError.parsingFailure
        }
    }
}
