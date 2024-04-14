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
    @Published private(set) var screenState: ScreenState = .downloading

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
                screenState = .downloading
                guard let artwork = media.artworkUrl100 else {
                    screenState = .content
                    return
                }
                let image = try await service
                    .mediaImage(imageURL: artwork)
                    .preparingForDisplay()
                self.image = image
                screenState = .content
            } catch let error as NetworkError {
                screenState = .error(message: error.rawValue)
            } catch {
                screenState = .error(message: "Something went wrong")
            }
        }
    }

    func getArtistInfo() {
        artistTask = Task {
            do {
                screenState = .downloading
                guard let artistId = media.artistId else {
                    screenState = .content
                    return
                }
                let artistResponse = try await service.artistLookup(artistId: artistId)
                guard let artistInfo = artistResponse.results.first else {
                    screenState = .content
                    return
                }
                self.artistInfo = artistInfo
                screenState = .content
            } catch let error as NetworkError {
                screenState = .error(message: error.rawValue)
            } catch {
                screenState = .error(message: "Something went wrong")
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
