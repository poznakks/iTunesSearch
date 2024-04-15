//
//  DetailViewController.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 14.04.2024.
//

import UIKit
import Combine

final class DetailViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: DetailViewModel
    private var cancellables: Set<AnyCancellable> = []

    private lazy var height = otherWorksCollectionView.heightAnchor.constraint(
        equalToConstant: 0
    )

    // MARK: - UI Elements
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

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(indicator)
        return indicator
    }()

    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        return label
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

    private lazy var additionalInfoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Additional info"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()

    private lazy var otherWorksButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .systemBlue
        config.title = "Show last 5 artist's works"
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(didTapOtherWorks), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)
        return button
    }()

    private lazy var otherWorksCollectionView: SearchResultsCollectionView = {
        let collectionView = SearchResultsCollectionView(scrollDirection: .horizontal)
        contentView.addSubview(collectionView)
        return collectionView
    }()

    // MARK: - Lifecycle
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

        otherWorksCollectionView.onCellTapHandler = { [weak self] media in
            guard let self else { return }
            let viewModel = DetailViewModel(media: media)
            let detailVC = DetailViewController(viewModel: viewModel)
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.cancelNetworkRequests()
    }
}

// MARK: - Actions
private extension DetailViewController {
    @objc
    func didTapLink() {
        viewModel.openItunesPage()
    }

    @objc
    func didTapArtistLink() {
        viewModel.openArtistPage()
    }

    @objc
    func didTapOtherWorks() {
        guard viewModel.otherWorks == nil else { return }
        viewModel.getOtherWorks()
    }
}

// MARK: - ViewModel Subscription
private extension DetailViewController {
    func subscribeOnViewModel() {
        viewModel.$image
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.imageView.image = image
            }
            .store(in: &cancellables)

        viewModel.$artistInfo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.setArtistInfo()
            }
            .store(in: &cancellables)

        viewModel.$otherWorks
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.setLastFiveWorks()
            }
            .store(in: &cancellables)

        viewModel.$screenState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.handleState()
            }
            .store(in: &cancellables)
    }

    func setArtistInfo() {
        guard let info = viewModel.artistInfo,
              viewModel.media.wrapperType != .artist
        else { return }

        aboutArtistLabel.isHidden = false
        artistNameLabel.text = "Name: " + info.artistName
        aboutArtistButton.isHidden = false

        guard let genre = info.primaryGenreName else { return }
        artistPrimaryGenreLabel.text = "Primary genre: " + genre
    }

    func setLastFiveWorks() {
        guard let media = viewModel.otherWorks else { return }
        otherWorksCollectionView.setMedia(media)
        UIView.animate(withDuration: 0.75, animations: {
            self.height.constant = 300
            self.scrollView.contentOffset.y += 300
            self.view.layoutIfNeeded()
        })
    }

    func handleState() {
        switch viewModel.screenState {
        case .downloading:
            activityIndicator.startAnimating()
            contentView.isHidden = true
            errorLabel.isHidden = true

        case .error(let message):
            activityIndicator.stopAnimating()
            contentView.isHidden = true
            errorLabel.isHidden = false
            errorLabel.text = message

        case .content:
            activityIndicator.stopAnimating()
            errorLabel.isHidden = true
            contentView.isHidden = false
        }
    }
}

// MARK: - Configure content
private extension DetailViewController {
    func configure() {
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

    func configureForTrack() {
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

    func configureForCollection() {
        let media = viewModel.media
        titleLabel.text = media.collectionName
        typeLabel.text = media.collectionType

        if viewModel.media.collectionViewUrl != nil {
            linkButton.isHidden = false
        }
    }

    func configureForArtist() {
        let media = viewModel.media
        titleLabel.text = media.artistName
        typeLabel.text = media.primaryGenreName

        if viewModel.media.artistLinkUrl != nil {
            linkButton.isHidden = false
        }
    }
}

// MARK: - Layout
// swiftlint:disable all
private extension DetailViewController {
    func setupConstraints() {
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

            additionalInfoLabel.topAnchor.constraint(equalTo: aboutArtistButton.bottomAnchor, constant: 10),
            additionalInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            additionalInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            otherWorksButton.topAnchor.constraint(equalTo: additionalInfoLabel.bottomAnchor, constant: 10),
            otherWorksButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            otherWorksButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            otherWorksCollectionView.topAnchor.constraint(
                equalTo: otherWorksButton.bottomAnchor,
                constant: 10
            ),
            otherWorksCollectionView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            otherWorksCollectionView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),
            otherWorksCollectionView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -30
            ),
            height,

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
// swiftlint:enable all
