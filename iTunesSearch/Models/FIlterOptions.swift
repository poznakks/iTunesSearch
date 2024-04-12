//
//  FIlterOptions.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 12.04.2024.
//

import Foundation

struct FilterOptions {
    let limit: Int
    let mediaTypes: [MediaType]
    let includeExplicit: Bool
    let entities: [Entity]
    let country: String
}
