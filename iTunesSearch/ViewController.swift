//
//  ViewController.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 06.04.2024.
//

import UIKit

final class ViewController: UIViewController {

    private lazy var searchResultsCollectionView = SearchResultsCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupConstraints()

        // swiftlint:disable force_try
        Task {
            let url = URL(string: "https://itunes.apple.com/search?entity=movie&term=pirates")!
            let (data, _) = try! await URLSession.shared.data(from: url)

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)

            let decoded = try! jsonDecoder.decode(MediaResponse.self, from: data)
            let media = decoded.results
            searchResultsCollectionView.setMedia(media)
        }
        // swiftlint:enable force_try
    }

    private func setupConstraints() {
        view.addSubview(searchResultsCollectionView)
        NSLayoutConstraint.activate([
            searchResultsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            searchResultsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            searchResultsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchResultsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
