//
//  CachePolicy.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 24.03.2024.
//

import Foundation

enum CachePolicy: TimeInterval {
    case noCache
    case oneHour = 3600
    case unlimited
}
