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

    private let service: ItunesService
    private var task: Task<Void, Never>?

    init(media: Media, service: ItunesService = ItunesServiceImpl()) {
        self.media = media
        self.service = service
    }

    func getImage() {
        task = Task {
            guard let artwork = media.artworkUrl100 else { return }
            guard !Task.isCancelled else { return }
            let image = try? await service
                .mediaImage(imageURL: artwork)
                .preparingForDisplay()
            // если картинка не пришла, то ее можно просто не отображать
            // на функциональность это никак не влияет
            // либо можно предусмотреть какую-нибудь placeholder картинку
            guard !Task.isCancelled else { return }
            self.image = image
        }
    }

    func cancelImageDownload() {
        task?.cancel()
    }
}
