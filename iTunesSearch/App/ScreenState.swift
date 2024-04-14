//
//  ScreenState.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 14.04.2024.
//

import Foundation

enum ScreenState {
    case downloading
    case content
    case error(message: String)
}
