//
//  FilterViewController.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 10.04.2024.
//

import UIKit

final class FilterViewController: UIViewController {

    private let limitOptions = [10, 30, 50]
    private var selectedMediaTypes = MediaType.allCases
    private var includeExplicit = true
    private var selectedEntities = Entity.allCases
    private var selectedCountry = Country.us

    private lazy var limitLabel: UILabel = {
        let label = UILabel()
        label.text = "Number of results"
        label.font = .systemFont(ofSize: 18, weight: .bold, design: .rounded)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var limitSegmentedControl: UISegmentedControl = {
        let sg = UISegmentedControl(items: limitOptions.map { "\($0)" })
        sg.selectedSegmentIndex = 1
        sg.backgroundColor = .systemGray6
        sg.translatesAutoresizingMaskIntoConstraints = false
        return sg
    }()

    private lazy var mediaTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "Media type"
        label.font = .systemFont(ofSize: 18, weight: .bold, design: .rounded)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var mediaTypeButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemGray5
        config.baseForegroundColor = .black
        config.title = "Any"
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(didTapMediaTypeButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        return button
    }()

    private lazy var explicitLabel: UILabel = {
        let label = UILabel()
        label.text = "Include explicit content"
        label.font = .systemFont(ofSize: 18, weight: .bold, design: .rounded)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var explicitSwitch: UISwitch = {
        let sw = UISwitch()
        sw.isOn = includeExplicit
        sw.translatesAutoresizingMaskIntoConstraints = false
        return sw
    }()

    private lazy var entityLabel: UILabel = {
        let label = UILabel()
        label.text = "Entity"
        label.font = .systemFont(ofSize: 18, weight: .bold, design: .rounded)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var entityButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemGray5
        config.baseForegroundColor = .black
        config.title = "Any"
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(didTapEntityButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        return button
    }()

    private lazy var countryLabel: UILabel = {
        let label = UILabel()
        label.text = "Country"
        label.font = .systemFont(ofSize: 18, weight: .bold, design: .rounded)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var countryButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemGray5
        config.baseForegroundColor = .black
        config.title = "US"
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(didTapCountryButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        return button
    }()

    private lazy var applyButton: ApplyFiltersButton = {
        let button = ApplyFiltersButton()
        button.addTarget(self, action: #selector(didTapApplyFilters), for: .touchUpInside)
        view.addSubview(button)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupConstraints()
    }

    private func setupConstraints() {
        let limitStack = makeStackView(label: limitLabel, control: limitSegmentedControl)
        let mediaTypeStack = makeStackView(label: mediaTypeLabel, control: mediaTypeButton)
        let explicitStack = makeStackView(label: explicitLabel, control: explicitSwitch)
        let entityStack = makeStackView(label: entityLabel, control: entityButton)
        let countryStack = makeStackView(label: countryLabel, control: countryButton)

        NSLayoutConstraint.activate([
            limitStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            limitStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            limitStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            limitSegmentedControl.heightAnchor.constraint(equalToConstant: 40),

            mediaTypeStack.topAnchor.constraint(equalTo: limitStack.bottomAnchor, constant: 20),
            mediaTypeStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mediaTypeStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mediaTypeButton.heightAnchor.constraint(equalToConstant: 40),

            explicitStack.topAnchor.constraint(equalTo: mediaTypeStack.bottomAnchor, constant: 20),
            explicitStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            explicitStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            entityStack.topAnchor.constraint(equalTo: explicitStack.bottomAnchor, constant: 20),
            entityStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            entityStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            entityButton.heightAnchor.constraint(equalToConstant: 40),

            countryStack.topAnchor.constraint(equalTo: entityStack.bottomAnchor, constant: 20),
            countryStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            countryStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            countryButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func makeStackView(label: UILabel, control: UIControl) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [label, control])
        stack.axis = .vertical
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        return stack
    }
}

// MARK: - Actions
private extension FilterViewController {
    @objc
    private func didTapMediaTypeButton() {
        let vc = MultiOptionViewController(options: MediaType.allCases.map { $0.toString })
        vc.didSelectOptions = { [weak self] selectedOptions in
            self?.mediaTypeButton.configuration?.title = selectedOptions.joined(separator: ", ")
        }
        present(vc, animated: true)
    }

    @objc
    private func didTapEntityButton() {
        let vc = MultiOptionViewController(options: Entity.allCases.map { $0.rawValue })
        vc.didSelectOptions = { [weak self] selectedOptions in
            self?.entityButton.configuration?.title = selectedOptions.joined(separator: ", ")
        }
        present(vc, animated: true)
    }

    @objc
    private func didTapCountryButton() {
        let vc = SingleOptionViewController(options: Country.allCases.map { $0.toString })
        vc.didSelectOption = { [weak self] selectedOption in
            self?.countryButton.configuration?.title = selectedOption
        }
        present(vc, animated: true)
    }

    @objc
    private func didTapApplyFilters() {
        dismiss(animated: true, completion: nil)
    }
}
