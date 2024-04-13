//
//  MediaImageRequest.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 13.04.2024.
//

import Foundation

struct MediaImageRequest: NetworkRequest {
    typealias Response = MediaImageResponse

    let baseURL: URL

    init(imageURL: URL) {
        self.baseURL = imageURL
    }
}
