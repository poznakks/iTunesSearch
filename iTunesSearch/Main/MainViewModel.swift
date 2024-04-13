//
//  MainViewModel.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 14.04.2024.
//

import Foundation

@MainActor
final class MainViewModel: ObservableObject {

    @Published var intermediateQuery: String = "" {
        didSet {
            searchAmongPreviousRequests()
        }
    }

    @Published var query: String = "" {
        didSet {
            performSearch()
            addRequestToPrevious()
        }
    }
    @Published var filters: Filters = .standard {
        didSet {
            query = intermediateQuery
        }
    }

    @Published private(set) var suggestions: [String] = []
    @Published private(set) var mediaResults: [Media] = []

    private var previousRequests: [String] = []

    private let mediaService: MediaService

    init(mediaService: MediaService = MediaServiceImpl()) {
        self.mediaService = mediaService
    }

    func getLastRequests() {
        let lastRequests = previousRequests.reversed()
        suggestions = Array(lastRequests)
    }

    private func performSearch() {
        Task {
            do {
                print(query)
                let receivedMedia = try await mediaService.media(query: query, filters: filters)
                mediaResults = receivedMedia.results
            } catch {
                print(error)
            }
        }
    }

    private func searchAmongPreviousRequests() {
        let previousRequests = previousRequests
            .filter { $0.range(of: intermediateQuery, options: .caseInsensitive) != nil }
            .reversed()
        suggestions = Array(previousRequests)
    }

    private func addRequestToPrevious() {
        if let index = previousRequests.firstIndex(of: query) {
            previousRequests.remove(at: index)
        }
        previousRequests.append(query)
        if previousRequests.count > 5 {
            previousRequests.remove(at: 0)
        }
    }
}
