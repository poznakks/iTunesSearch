//
//  ApplyFiltersButton.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 11.04.2024.
//

import UIKit

final class ApplyFiltersButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButton() {
        var config = UIButton.Configuration.filled()
        config.title = "Apply filters"
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .systemBlue
        self.configuration = config
        layer.masksToBounds = false // allow the shadow to be visible outside the bounds
        translatesAutoresizingMaskIntoConstraints = false
        setupShadow()
    }

    private func setupShadow() {
        layer.shadowColor = UIColor.systemBlue.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 44 / 8
    }
}
