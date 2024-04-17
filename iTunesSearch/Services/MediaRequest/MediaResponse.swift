//
//  MediaResponse.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 13.04.2024.
//

import Foundation

struct MediaResponse: Decodable {
    let resultCount: Int
    let results: [Media]
}
