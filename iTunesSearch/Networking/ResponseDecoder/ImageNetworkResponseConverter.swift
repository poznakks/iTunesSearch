//
//  ImageNetworkResponseConverter.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 24.03.2024.
//

import UIKit

final class ImageNetworkResponseConverter: NetworkResponseConverter {

    func decodeResponse(from data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw NetworkError.parsingFailure
        }
        return image
    }
}
