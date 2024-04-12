//
//  OptionsTableViewCell.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 11.04.2024.
//

import UIKit

enum OptionsType {
    case single
    case multi
}

final class OptionsTableViewCell: UITableViewCell {

    static let identifier = String(describing: OptionsTableViewCell.self)

    var type: OptionsType = .single

    var isChosen = false {
        didSet {
            let imageName: String
            switch type {
            case .single:
                imageName = isChosen ? "circle.inset.filled" : "circle"
            case .multi:
                imageName = isChosen ? "checkmark.square.fill" : "square"
            }
            image.image = UIImage(systemName: imageName)
        }
    }

    var text: String = "" {
        didSet {
            label.text = text
        }
    }

    private lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        return imageView
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular, design: .rounded)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),

            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 5)
        ])
    }
}
