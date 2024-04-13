//
//  MainViewController.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 06.04.2024.
//

import UIKit

final class MainViewController: UIViewController {

    private var query: String = ""
    private var filters: Filters = .standard
    private var previousRequests: [String] = []

    private lazy var searchTextField = SearchTextField()
    private lazy var searchSuggestionsTableView = SearchSuggestionsTableView()
    private lazy var searchResultsCollectionView = SearchResultsCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        searchSuggestionsTableView.isHidden = true
        setupConstraints()

        searchTextField.onStartEditing = { [weak self] in
            guard let self else { return }
            let lastRequests = self.getLastRequests()
            searchSuggestionsTableView.setResults(lastRequests)
            searchSuggestionsTableView.isHidden = false
        }

        searchTextField.onTextUpdate = { [weak self] text in
            guard let self else { return }
            let previousRequests = self.searchAmongPreviousRequests(for: text)
            searchSuggestionsTableView.setResults(previousRequests)
            searchSuggestionsTableView.isHidden = false
        }

        searchTextField.onReturn = { [weak self] text in
            guard let self else { return }
            self.query = text
            self.performSearch(query: text)
            self.addRequestToPrevious(text)
            searchSuggestionsTableView.isHidden = true
        }

        searchTextField.showFilters = { [weak self] in
            guard let self else { return }
            let filterViewController = FilterViewController(filters: filters)
            filterViewController.didSetFilters = { filters in
                self.filters = filters
                self.performSearch(query: self.query)
            }
            self.present(filterViewController, animated: true)
        }

        searchSuggestionsTableView.onCellTapHandler = { [weak self] suggestion in
            guard let self else { return }
            self.performSearch(query: suggestion)
            self.searchTextField.text = suggestion
            self.searchTextField.resignFirstResponder()
            self.addRequestToPrevious(suggestion)
            searchSuggestionsTableView.isHidden = true
        }
    }

    private func setupConstraints() {
        view.addSubview(searchTextField)
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 40)
        ])

        view.addSubview(searchResultsCollectionView)
        NSLayoutConstraint.activate([
            searchResultsCollectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16),
            searchResultsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            searchResultsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchResultsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        view.addSubview(searchSuggestionsTableView)
        NSLayoutConstraint.activate([
            searchSuggestionsTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor),
            searchSuggestionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchSuggestionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchSuggestionsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func performSearch(query: String) {
        // swiftlint:disable force_try force_unwrapping
        Task {
            let url = URL(string: "https://itunes.apple.com/search?entity=movie&term=\(query)")!
            let (data, _) = try! await URLSession.shared.data(from: url)

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)

            let decoded = try! jsonDecoder.decode(MediaResponse.self, from: data)
            let media = decoded.results
            searchResultsCollectionView.setMedia(media)
        }
        // swiftlint:enable force_try force_unwrapping
    }
}

private extension MainViewController {
    func getLastRequests() -> [String] {
        previousRequests.reversed()
    }

    func searchAmongPreviousRequests(for substring: String) -> [String] {
        previousRequests
            .filter { $0.range(of: substring, options: .caseInsensitive) != nil }
            .reversed()
    }

    func addRequestToPrevious(_ request: String) {
        if let index = previousRequests.firstIndex(of: request) {
            previousRequests.remove(at: index)
        }
        previousRequests.append(request)
        if previousRequests.count > 5 {
            previousRequests.remove(at: 0)
        }
    }
}
