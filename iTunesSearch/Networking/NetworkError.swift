//
//  NetworkError.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 24.03.2024.
//

import Foundation

enum NetworkError: String, Error {
    case cantBuildUrlFromRequest = "Incorrect URL"
    case badResponse = "Bad response"
    case noInternetConnection = "No internet connection"
    case parsingFailure = "Parsing failure"
    case timeout = "Connection timed out"
    case networkError = "Something went wrong"
}
