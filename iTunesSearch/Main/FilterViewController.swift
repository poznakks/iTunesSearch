//
//  FilterViewController.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 10.04.2024.
//

import UIKit

final class FilterViewController: UIViewController {

    var didSetFilters: ((Filters) -> Void)?

    private var filters: Filters

    private let limitOptions = [10, 30, 50]

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
        config.title = filters.entities.map { $0.toString }.joined(separator: ", ")
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(didTapEntityButton), for: .touchUpInside)
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
        sw.isOn = filters.includeExplicit
        sw.translatesAutoresizingMaskIntoConstraints = false
        return sw
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
        config.title = filters.country.toString
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

    init(filters: Filters) {
        self.filters = filters
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupConstraints()
    }

    private func setupConstraints() {
        let limitStack = makeStackView(label: limitLabel, control: limitSegmentedControl)
        let entityStack = makeStackView(label: entityLabel, control: entityButton)
        let explicitStack = makeStackView(label: explicitLabel, control: explicitSwitch)
        let countryStack = makeStackView(label: countryLabel, control: countryButton)

        NSLayoutConstraint.activate([
            limitStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            limitStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            limitStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            limitSegmentedControl.heightAnchor.constraint(equalToConstant: 40),

            entityStack.topAnchor.constraint(equalTo: limitStack.bottomAnchor, constant: 20),
            entityStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            entityStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            entityButton.heightAnchor.constraint(equalToConstant: 40),

            explicitStack.topAnchor.constraint(equalTo: entityStack.bottomAnchor, constant: 20),
            explicitStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            explicitStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            countryStack.topAnchor.constraint(equalTo: explicitStack.bottomAnchor, constant: 20),
            countryStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            countryStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            countryButton.heightAnchor.constraint(equalToConstant: 40),

            applyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            applyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -54),
            applyButton.heightAnchor.constraint(equalToConstant: 40)
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
    func didTapEntityButton() {
        let vc = MultiOptionViewController(
            options: Entity.allCases,
            selected: filters.entities
        )
        vc.didSelectOptions = { [weak self] selectedOptions in
            self?.filters.entities = selectedOptions
            self?.entityButton.configuration?.title = selectedOptions
                .map { $0.toString }
                .joined(separator: ", ")
        }
        present(vc, animated: true)
    }

    @objc
    func didTapCountryButton() {
        let vc = SingleOptionViewController(
            options: Country.allCases,
            selected: filters.country
        )
        vc.didSelectOption = { [weak self] selectedOption in
            self?.filters.country = selectedOption
            self?.countryButton.configuration?.title = selectedOption.toString
        }
        present(vc, animated: true)
    }

    @objc
    func didTapApplyFilters() {
        didSetFilters?(filters)
        dismiss(animated: true, completion: nil)
    }
}
