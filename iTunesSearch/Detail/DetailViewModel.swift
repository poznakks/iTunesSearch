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
    @Published private(set) var otherWorks: [Media]?
    @Published private(set) var screenState: ScreenState = .downloading

    private let service: ItunesService
    private var imageTask: Task<Void, Never>?
    private var artistTask: Task<Void, Never>?
    private var otherWorksTask: Task<Void, Never>?

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
                guard !Task.isCancelled else { return }
                let image = try await service
                    .mediaImage(imageURL: artwork)
                    .preparingForDisplay()

                guard !Task.isCancelled else { return }
                self.image = image
                screenState = .content
            } catch let error as NetworkError {
                screenState = .error(message: error.rawValue)
            } catch {
                screenState = .error(message: "Cannot fetch image")
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

                guard !Task.isCancelled else { return }
                let artistResponse = try await service.artistLookup(artistId: artistId)
                guard let artistInfo = artistResponse.results.first else {
                    screenState = .content
                    return
                }

                guard !Task.isCancelled else { return }
                self.artistInfo = artistInfo
                screenState = .content
            } catch let error as NetworkError {
                screenState = .error(message: error.rawValue)
            } catch {
                screenState = .error(message: "Cannot fetch artist info")
            }
        }
    }

    func getOtherWorks() {
        otherWorksTask = Task {
            do {
                guard let artistId = media.artistId else { return }
                let worksResponse = try await service.artistOtherWorks(artistId: artistId)
                let works = worksResponse.results.dropFirst() // first is artist info
                self.otherWorks = Array(works)
            } catch let error as NetworkError {
                screenState = .error(message: error.rawValue)
            } catch {
                screenState = .error(message: "Cannot fetch last 5 works")
            }
        }
    }

    func cancelNetworkRequests() {
        imageTask?.cancel()
        artistTask?.cancel()
        otherWorksTask?.cancel()
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
