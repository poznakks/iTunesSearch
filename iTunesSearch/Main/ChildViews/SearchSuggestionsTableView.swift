//
//  SearchSuggestionsTableView.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 10.04.2024.
//

import UIKit

final class SearchSuggestionsTableView: UITableView {

    var onCellTapHandler: ((String) -> Void)?

    private var suggestions: [String] = []

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setResults(_ suggestions: [String]) {
        self.suggestions = suggestions
        reloadData()
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        dataSource = self
        delegate = self
        register(
            UITableViewCell.self,
            forCellReuseIdentifier: String(describing: UITableViewCell.self)
        )
    }
}

extension SearchSuggestionsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        suggestions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(
            withIdentifier: String(describing: UITableViewCell.self),
            for: indexPath
        )
        let result = suggestions[indexPath.row]
        cell.backgroundColor = .systemBackground
        cell.textLabel?.text = result
        return cell
    }
}

extension SearchSuggestionsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedResult = suggestions[indexPath.row]
        onCellTapHandler?(selectedResult)
    }
}
