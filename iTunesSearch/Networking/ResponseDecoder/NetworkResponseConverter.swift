//
//  NetworkResponseConverter.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 24.03.2024.
//

import Foundation

protocol NetworkResponseConverter {
    associatedtype Response

    func decodeResponse(from data: Data) throws -> Response
}
