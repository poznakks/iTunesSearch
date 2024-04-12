//
//  SearchResultCell.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 06.04.2024.
//

import UIKit

final class SearchResultCell: UICollectionViewCell {

    static let identifier = String(describing: SearchResultCell.self)

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .systemGray5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()

    private lazy var artistLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .systemGray
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()

    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()

    private lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "$19.99"
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        priceLabel.text = nil
        imageView.image = nil
    }

    // swiftlint:disable force_try
    func configure(with media: Media) {
        titleLabel.text = media.trackName
        artistLabel.text = media.artistName
        typeLabel.text = media.kind.toString
        durationLabel.text = media.trackDurationString

        if let trackPrice = media.trackPrice {
            priceLabel.text = "\(trackPrice) \(media.currency)"
        } else {
            priceLabel.text = "Price not specified"
        }
        Task {
            let (data, _) = try! await URLSession.shared.data(from: media.artworkUrl100)
            let image = UIImage(data: data)?.preparingForDisplay()
            imageView.image = image
        }
    }
    // swiftlint:enable force_try

    private func setupConstraints() {
        let stack: UIStackView = {
            let stack = UIStackView(
                arrangedSubviews: [
                    imageView,
                    titleLabel,
                    artistLabel,
                    typeLabel,
                    durationLabel,
                    priceLabel
                ]
            )
            stack.axis = .vertical
            stack.distribution = .equalSpacing
            stack.translatesAutoresizingMaskIntoConstraints = false
            addSubview(stack)
            return stack
        }()

        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}