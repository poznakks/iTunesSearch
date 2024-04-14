//
//  FiltersViewController.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 10.04.2024.
//

import UIKit
import Combine

final class FiltersViewController: UIViewController {

    var didSetFilters: ((Filters) -> Void)?

    private let viewModel: FiltersViewModel
    private var cancellables: Set<AnyCancellable> = []

    private lazy var limitLabel = makeLabel(text: "Number of results")

    private lazy var limitSegmentedControl: UISegmentedControl = {
        let sg = UISegmentedControl(items: viewModel.limitOptions.asString())
        sg.selectedSegmentIndex = viewModel.selectedLimitIndex
        sg.backgroundColor = .systemGray6
        sg.addTarget(self, action: #selector(didChangeLimit), for: .valueChanged)
        sg.translatesAutoresizingMaskIntoConstraints = false
        return sg
    }()

    private lazy var entityLabel = makeLabel(text: "Entity")

    private lazy var entityButton = makeOptionsButton(
        title: viewModel.entitiesString,
        action: #selector(didTapEntityButton)
    )

    private lazy var explicitLabel = makeLabel(text: "Include explicit content")

    private lazy var explicitSwitch: UISwitch = {
        let sw = UISwitch()
        sw.isOn = viewModel.includeExplicit
        sw.addTarget(self, action: #selector(didChangeExplicit), for: .valueChanged)
        sw.translatesAutoresizingMaskIntoConstraints = false
        return sw
    }()

    private lazy var countryLabel = makeLabel(text: "Country")

    private lazy var countryButton = makeOptionsButton(
        title: viewModel.countryString,
        action: #selector(didTapCountryButton)
    )

    private lazy var applyButton: ApplyFiltersButton = {
        let button = ApplyFiltersButton()
        button.addTarget(self, action: #selector(didTapApplyFilters), for: .touchUpInside)
        view.addSubview(button)
        return button
    }()

    init(viewModel: FiltersViewModel) {
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
        setupConstraints()
        subscribeOnViewModel()
    }

    private func subscribeOnViewModel() {
        viewModel.$entities
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.entityButton.configuration?.title = self?.viewModel.entitiesString
            }
            .store(in: &cancellables)

        viewModel.$country
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.countryButton.configuration?.title = self?.viewModel.countryString
            }
            .store(in: &cancellables)
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

    private func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 18, weight: .bold, design: .rounded)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func makeOptionsButton(title: String, action: Selector) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemGray5
        config.baseForegroundColor = .black
        config.title = title
        let button = UIButton(configuration: config)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}

// MARK: - Actions
private extension FiltersViewController {
    @objc
    func didChangeLimit() {
        viewModel.selectedLimitIndex = limitSegmentedControl.selectedSegmentIndex
    }

    @objc
    func didTapEntityButton() {
        let vc = MultiOptionViewController(
            options: Entity.allCases,
            selected: viewModel.entities
        )
        vc.didSelectOptions = { [weak self] selectedOptions in
            self?.viewModel.entities = selectedOptions
        }
        present(vc, animated: true)
    }

    @objc
    func didChangeExplicit() {
        viewModel.includeExplicit = explicitSwitch.isOn
    }

    @objc
    func didTapCountryButton() {
        let vc = SingleOptionViewController(
            options: Country.allCases,
            selected: viewModel.country
        )
        vc.didSelectOption = { [weak self] selectedOption in
            self?.viewModel.country = selectedOption
        }
        present(vc, animated: true)
    }

    @objc
    func didTapApplyFilters() {
        didSetFilters?(viewModel.filters)
        dismiss(animated: true, completion: nil)
    }
}
