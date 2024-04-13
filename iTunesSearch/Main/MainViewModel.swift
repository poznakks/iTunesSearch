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

    private let service: MediaService

    init(service: MediaService = MediaServiceImpl()) {
        self.service = service
    }

    func getLastRequests() {
        suggestions = previousRequests.reversed()
    }

    private func performSearch() {
        Task {
            do {
                let receivedMedia = try await service.media(query: query, filters: filters)
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
