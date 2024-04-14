//
//  FiltersViewModel.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 14.04.2024.
//

import Foundation

@MainActor
final class FiltersViewModel: ObservableObject {

    var selectedLimitIndex = 1
    let limitOptions = [10, 30, 50]

    @Published var entities: [Entity] = Entity.allCases
    var entitiesString: String {
        entities.map { $0.toString }.joined(separator: ", ")
    }

    @Published var country: Country = .us
    var countryString: String {
        country.toString
    }

    var includeExplicit = true

    var filters: Filters {
        Filters(
            limit: limitOptions[selectedLimitIndex],
            entities: entities,
            includeExplicit: includeExplicit,
            country: country
        )
    }

    init(filters: Filters) {
        self.selectedLimitIndex = limitOptions.firstIndex(where: { $0 == filters.limit }) ?? 1
        self.entities = filters.entities
        self.includeExplicit = filters.includeExplicit
        self.country = filters.country
    }
}
