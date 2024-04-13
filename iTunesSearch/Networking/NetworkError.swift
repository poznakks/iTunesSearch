//
//  NetworkError.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 24.03.2024.
//

import Foundation

enum NetworkError: Error {
    case cantBuildUrlFromRequest
    case badResponse
    case noInternetConnection
    case parsingFailure
    case timeout
    case networkError
}
