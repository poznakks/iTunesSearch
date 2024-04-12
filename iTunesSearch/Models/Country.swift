//
//  Country.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 12.04.2024.
//

import Foundation

enum Country: String, CaseIterable {
    case us = "us"
    case uk = "uk"
    case russia = "ru"
    case canada = "ca"

    var toString: String {
        switch self {
        case .us:
            return "US"
        case .uk:
            return "UK"
        case .russia:
            return "Russia"
        case .canada:
            return "Canada"
        }
    }
}
