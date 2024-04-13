//
//  Filters.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 12.04.2024.
//

import Foundation

struct Filters {
    var limit: Int
    var entities: [Entity]
    var includeExplicit: Bool
    var country: Country

    static let standard = Filters(
        limit: 30,
        entities: Entity.allCases,
        includeExplicit: true,
        country: .us
    )
}
