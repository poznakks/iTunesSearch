//
//  Array+asString.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 14.04.2024.
//

import Foundation

extension Array where Element: CustomStringConvertible {
    func asString() -> [String] {
        self.map { String(describing: $0) }
    }
}
