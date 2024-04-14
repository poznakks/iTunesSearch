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
    @Published private(set) var screenState: ScreenState = .content

    private var previousRequests: [String] = []

    private let service: ItunesService

    init(service: ItunesService = ItunesServiceImpl()) {
        self.service = service
    }

    func getLastRequests() {
        screenState = .content
        suggestions = previousRequests.reversed()
    }

    private func performSearch() {
        Task {
            do {
                screenState = .downloading
                let receivedMedia = try await service.media(query: query, filters: filters)
                screenState = .content
                mediaResults = receivedMedia.results
            } catch let error as NetworkError {
                screenState = .error(message: error.rawValue)
            } catch {
                screenState = .error(message: "Something went wrong")
            }
        }
    }

    private func searchAmongPreviousRequests() {
        screenState = .content
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
