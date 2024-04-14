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

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var searchTextField = SearchTextField()
    private lazy var searchSuggestionsTableView = SearchSuggestionsTableView()
    private lazy var searchResultsCollectionView = SearchResultsCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        subscribeOnViewModel()
        setTapHandlers()
        setupConstraints()

        searchTextField.searchDelegate = self
        searchSuggestionsTableView.isHidden = true
    }

    private func setTapHandlers() {
        searchSuggestionsTableView.onCellTapHandler = { [weak self] suggestion in
            guard let self else { return }
            self.onReturn(suggestion)
            self.searchTextField.text = suggestion
            self.searchTextField.resignFirstResponder()
        }

        searchResultsCollectionView.onCellTapHandler = { [weak self] media in
            guard let self else { return }
            let viewModel = DetailViewModel(media: media)
            let detailVC = DetailViewController(viewModel: viewModel)
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    private func subscribeOnViewModel() {
        viewModel.$suggestions
            .receive(on: DispatchQueue.main)
            .sink { [weak self] suggestions in
                self?.searchSuggestionsTableView.setResults(suggestions)
                self?.searchSuggestionsTableView.isHidden = false
            }
            .store(in: &cancellables)

        viewModel.$mediaResults
            .receive(on: DispatchQueue.main)
            .sink { [weak self] media in
                self?.searchResultsCollectionView.setMedia(media)
                self?.searchSuggestionsTableView.isHidden = true
                self?.searchResultsCollectionView.isHidden = false
            }
            .store(in: &cancellables)

        viewModel.$screenState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.handleState()
            }
            .store(in: &cancellables)
    }

    private func handleState() {
        switch viewModel.screenState {
        case .downloading:
            activityIndicator.startAnimating()
            searchResultsCollectionView.isHidden = true
            searchSuggestionsTableView.isHidden = true
            errorLabel.isHidden = true

        case .error(let message):
            activityIndicator.stopAnimating()
            searchResultsCollectionView.isHidden = true
            searchSuggestionsTableView.isHidden = true
            errorLabel.isHidden = false
            errorLabel.text = message

        case .content:
            activityIndicator.stopAnimating()
            errorLabel.isHidden = true
            searchResultsCollectionView.isHidden = false
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

        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        view.addSubview(errorLabel)
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension MainViewController: SearchTextFieldDelegate {
    func onStartEditing() {
        viewModel.getLastRequests()
    }

    func onTextUpdate(_ text: String) {
        viewModel.intermediateQuery = text
    }

    func onReturn(_ text: String) {
        viewModel.query = text
    }

    func onShowFilters() {
        let filtersViewModel = FiltersViewModel(filters: viewModel.filters)
        let filtersViewController = FiltersViewController(viewModel: filtersViewModel)
        filtersViewController.didSetFilters = { [weak self] filters in
            self?.viewModel.filters = filters
        }
        present(filtersViewController, animated: true)
    }
}
