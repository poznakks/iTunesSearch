//
//  CachePolicy.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 24.03.2024.
//

import Foundation

enum CachePolicy {
    case noCache
    case inMemory(CacheTime)
}

enum CacheTime: TimeInterval {
    case unlimited
}
