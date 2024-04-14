//
//  MainViewController.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 06.04.2024.
//

import UIKit
import Combine

final class MainViewController: UIViewController {

    private let viewModel = MainViewModel()
    private var cancellables: Set<AnyCancellable> = []

    private lazy var searchTextField = SearchTextField()
    private lazy var searchSuggestionsTableView = SearchSuggestionsTableView()
    private lazy var searchResultsCollectionView = SearchResultsCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        subscribeOnViewModel()
        setupConstraints()

        searchTextField.searchDelegate = self
        searchSuggestionsTableView.isHidden = true

        searchSuggestionsTableView.onCellTapHandler = { [weak self] suggestion in
            guard let self else { return }
            self.onReturn(suggestion)
            self.searchTextField.text = suggestion
            self.searchTextField.resignFirstResponder()
        }
    }

    private func subscribeOnViewModel() {
        viewModel.$suggestions
            .receive(on: DispatchQueue.main)
            .sink { [weak self] suggestions in
                self?.searchSuggestionsTableView.setResults(suggestions)
            }
            .store(in: &cancellables)

        viewModel.$mediaResults
            .receive(on: DispatchQueue.main)
            .sink { [weak self] media in
                self?.searchResultsCollectionView.setMedia(media)
            }
            .store(in: &cancellables)
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
}

extension MainViewController: SearchTextFieldDelegate {
    func onStartEditing() {
        viewModel.getLastRequests()
        searchSuggestionsTableView.isHidden = false
    }

    func onTextUpdate(_ text: String) {
        viewModel.intermediateQuery = text
        searchSuggestionsTableView.isHidden = false
    }

    func onReturn(_ text: String) {
        viewModel.query = text
        searchSuggestionsTableView.isHidden = true
    }

    func onShowFilters() {
        let filtersViewModel = FiltersViewModel(filters: viewModel.filters)
        let filtersViewController = FiltersViewController(viewModel: filtersViewModel)
        filtersViewController.didSetFilters = { [weak self] filters in
            self?.viewModel.filters = filters
            self?.searchSuggestionsTableView.isHidden = true
        }
        present(filtersViewController, animated: true)
    }
}
