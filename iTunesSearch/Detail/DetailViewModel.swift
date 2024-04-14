//
//  DetailViewModel.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 14.04.2024.
//

import UIKit

@MainActor
final class DetailViewModel: ObservableObject {

    let media: Media

    @Published private(set) var image: UIImage?
    @Published private(set) var artistInfo: ArtistInfo?

    private let service: ItunesService
    private var imageTask: Task<Void, Never>?
    private var artistTask: Task<Void, Never>?

    init(media: Media, service: ItunesService = ItunesServiceImpl()) {
        self.media = media
        self.service = service
    }

    func getImage() {
        imageTask = Task {
            do {
                guard let artwork = media.artworkUrl100 else { return }
                let image = try await service
                    .mediaImage(imageURL: artwork)
                    .preparingForDisplay()
                self.image = image
            } catch {
                // если картинка не пришла, то ее можно просто не отображать
                // на функциональность это никак не влияет
                // либо можно предусмотреть какую-нибудь placeholder картинку
                print(error)
            }
        }
    }

    func getArtistInfo() {
        artistTask = Task {
            do {
                guard let artistId = media.artistId else { return }
                let artistResponse = try await service.artistLookup(artistId: artistId)
                guard let artistInfo = artistResponse.results.first else { return }
                self.artistInfo = artistInfo
            } catch {
                print(error)
            }
        }
    }

    func cancelNetworkRequests() {
        imageTask?.cancel()
        artistTask?.cancel()
    }

    func openItunesPage() {
        let url: URL?
        switch media.wrapperType {
        case .track:
            url = media.trackViewUrl

        case .collection:
            url = media.collectionViewUrl

        case .artist:
            url = media.artistLinkUrl
        }
        guard let url else { return }
        UIApplication.shared.open(url)
    }

    func openArtistPage() {
        guard let url = artistInfo?.artistLinkUrl else { return }
        UIApplication.shared.open(url)
    }
}
