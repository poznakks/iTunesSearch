//
//  SearchResultsCollectionView.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 06.04.2024.
//

import UIKit

final class SearchResultsCollectionView: UICollectionView {

    private var media: [Media] = []

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setMedia(_ media: [Media]) {
        self.media = media
        reloadData()
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        delegate = self
        dataSource = self
        register(SearchResultCell.self, forCellWithReuseIdentifier: SearchResultCell.identifier)
    }
}

extension SearchResultsCollectionView: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        media.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: SearchResultCell.identifier,
            for: indexPath
        ) as? SearchResultCell else { return UICollectionViewCell() }
        let cellViewModel = SearchResultCellViewModel(media: media[indexPath.row])
        cell.configure(with: cellViewModel)
        return cell
    }
}

extension SearchResultsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = Constants.cellWidth(frameWidth: frame.width)
        return CGSize(width: width, height: width * 1.8)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(
            top: Constants.cellSpacing,
            left: Constants.cellSpacing,
            bottom: Constants.cellSpacing,
            right: Constants.cellSpacing
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        Constants.cellSpacing
    }
}

private enum Constants {
    static let cellSpacing: CGFloat = 16
    static let numberOfColumns: CGFloat = 2
    static let totalSpacing: CGFloat = (numberOfColumns + 1) * cellSpacing

    static func cellWidth(frameWidth: CGFloat) -> CGFloat {
        (frameWidth - totalSpacing) / numberOfColumns
    }
}
