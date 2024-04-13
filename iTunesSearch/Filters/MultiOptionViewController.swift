//
//  MultiOptionViewController.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 11.04.2024.
//

import UIKit

final class MultiOptionViewController<T: SelectableOption>:
    UIViewController, UITableViewDataSource, UITableViewDelegate {

    var didSelectOptions: (([T]) -> Void)?

    private let options: [T]
    private var selected: Set<T>

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(OptionsTableViewCell.self, forCellReuseIdentifier: OptionsTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        return tableView
    }()

    private lazy var applyButton: ApplyFiltersButton = {
        let button = ApplyFiltersButton()
        button.addTarget(self, action: #selector(didTapApplyFilters), for: .touchUpInside)
        view.addSubview(button)
        return button
    }()

    init(options: [T], selected: [T]) {
        self.options = options
        self.selected = Set(selected)
        super.init(nibName: nil, bundle: nil)
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),

            applyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            applyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -54),
            applyButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc
    private func didTapApplyFilters() {
        let selectedOptions = options.filter { selected.contains($0) }
        didSelectOptions?(selectedOptions)
        dismiss(animated: true, completion: nil)
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: OptionsTableViewCell.identifier,
            for: indexPath
        ) as? OptionsTableViewCell else { return UITableViewCell() }

        let option = options[indexPath.row]
        cell.type = .multi
        cell.text = option.toString
        cell.isChosen = selected.contains(option)

        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(
            at: indexPath
        ) as? OptionsTableViewCell else { return }

        if cell.isChosen {
            cell.isChosen = false
            selected.remove(options[indexPath.row])
        } else {
            cell.isChosen = true
            selected.insert(options[indexPath.row])
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
