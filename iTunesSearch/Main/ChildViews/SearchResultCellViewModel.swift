//
//  SearchResultCellViewModel.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 14.04.2024.
//

import UIKit

@MainActor
final class SearchResultCellViewModel: ObservableObject {

    let media: Media

    @Published private(set) var image: UIImage?

    private let service: MediaService
    private var task: Task<Void, Never>?

    init(media: Media, service: MediaService = MediaServiceImpl()) {
        self.media = media
        self.service = service
    }

    func getImage() {
        task = Task {
            guard let artwork = media.artworkUrl100 else { return }
            let image = try? await service.mediaImage(imageURL: artwork)
            // если картинка не пришла, то ее можно просто не отображать
            // на функциональность это никак не влияет
            // либо можно предусмотреть какую-нибудь placeholder картинку
            self.image = image
        }
    }

    func cancelImageDownload() {
        task?.cancel()
    }
}
