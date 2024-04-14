//
//  DetailViewController.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 14.04.2024.
//

import UIKit
import Combine

final class DetailViewController: UIViewController {

    private let viewModel: DetailViewModel
    private var cancellables: Set<AnyCancellable> = []

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        return scrollView
    }()

    private lazy var contentView: UIView = { // content view for scroll view
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()

    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()

    private lazy var linkButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .systemBlue
        config.title = "iTunes Page"
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(didTapLink), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)
        return button
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()

    private lazy var descriptionText: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()

    private lazy var aboutArtistLabel: UILabel = {
        let label = UILabel()
        label.text = "About artist"
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()

    private lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()

    private lazy var artistPrimaryGenreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()

    private lazy var aboutArtistButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .systemBlue
        config.title = "Artist iTunes page"
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(didTapArtistLink), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)
        return button
    }()

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        subscribeOnViewModel()
        configure()
        setupConstraints()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.cancelNetworkRequests()
    }

    private func subscribeOnViewModel() {
        viewModel.$image
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.imageView.image = image
            }
            .store(in: &cancellables)

        viewModel.$artistInfo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] info in
                guard let self,
                      let info,
                      viewModel.media.wrapperType != .artist
                else { return }

                self.aboutArtistLabel.isHidden = false
                self.artistNameLabel.text = "Name: " + info.artistName
                self.aboutArtistButton.isHidden = false

                guard let genre = info.primaryGenreName else { return }
                self.artistPrimaryGenreLabel.text = "Primary genre: " + genre
            }
            .store(in: &cancellables)
    }

    private func configure() {
        viewModel.getImage()
        viewModel.getArtistInfo()

        switch viewModel.media.wrapperType {
        case .track:
            configureForTrack()

        case .collection:
            configureForCollection()

        case .artist:
            configureForArtist()
        }
    }

    private func configureForTrack() {
        let media = viewModel.media
        titleLabel.text = media.trackName
        typeLabel.text = media.kind?.toString

        if let trackPrice = media.trackPrice,
           let currency = media.currency {
            priceLabel.text = "\(trackPrice) \(currency)"
        } else {
            priceLabel.text = "Price not specified"
        }

        if viewModel.media.trackViewUrl != nil {
            linkButton.isHidden = false
        }

        if let description = media.longDescription {
            descriptionLabel.isHidden = false
            descriptionText.text = description
        }
    }

    private func configureForCollection() {
        let media = viewModel.media
        titleLabel.text = media.collectionName
        typeLabel.text = media.collectionType

        if viewModel.media.collectionViewUrl != nil {
            linkButton.isHidden = false
        }
    }

    private func configureForArtist() {
        let media = viewModel.media
        titleLabel.text = media.artistName
        typeLabel.text = media.primaryGenreName

        if viewModel.media.artistLinkUrl != nil {
            linkButton.isHidden = false
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            typeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            typeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            typeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            priceLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 10),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            linkButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10),
            linkButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            linkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: linkButton.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            descriptionText.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            descriptionText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            aboutArtistLabel.topAnchor.constraint(equalTo: descriptionText.bottomAnchor, constant: 10),
            aboutArtistLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            aboutArtistLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            artistNameLabel.topAnchor.constraint(equalTo: aboutArtistLabel.bottomAnchor, constant: 10),
            artistNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            artistPrimaryGenreLabel.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: 10),
            artistPrimaryGenreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            artistPrimaryGenreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            aboutArtistButton.topAnchor.constraint(equalTo: artistPrimaryGenreLabel.bottomAnchor, constant: 10),
            aboutArtistButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            aboutArtistButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            aboutArtistButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    @objc
    private func didTapLink() {
        viewModel.openItunesPage()
    }

    @objc
    private func didTapArtistLink() {
        viewModel.openArtistPage()
    }
}
