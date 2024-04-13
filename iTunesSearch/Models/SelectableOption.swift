//
//  SelectableOption.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 13.04.2024.
//

import Foundation

protocol SelectableOption: CaseIterable, Hashable {
    var toString: String { get }
}
