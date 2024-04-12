//
//  SingleOptionViewController.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 11.04.2024.
//

import UIKit

final class SingleOptionViewController: UIViewController {

    var didSelectOption: ((String) -> Void)?

    private let options: [String]
    private var selectedIndex: Int

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

    init(options: [String]) {
        self.options = options
        self.selectedIndex = 0
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
        didSelectOption?(options[selectedIndex])
        dismiss(animated: true, completion: nil)
    }
}

extension SingleOptionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: OptionsTableViewCell.identifier,
            for: indexPath
        ) as? OptionsTableViewCell else { return UITableViewCell() }

        let option = options[indexPath.row]
        cell.type = .single
        cell.text = option
        cell.isChosen = indexPath.row == selectedIndex

        return cell
    }
}

extension SingleOptionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previousIndexPath = IndexPath(row: selectedIndex, section: 0)
        guard let previousCell = tableView.cellForRow(
            at: previousIndexPath
        ) as? OptionsTableViewCell else { return }

        previousCell.isChosen = false

        guard let cell = tableView.cellForRow(
            at: indexPath
        ) as? OptionsTableViewCell else { return }
        cell.isChosen = true

        selectedIndex = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
