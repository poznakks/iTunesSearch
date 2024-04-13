//
//  SearchTextField.swift
//  iTunesSearch
//
//  Created by Vlad Boguzh on 06.04.2024.
//

import UIKit

@MainActor
protocol SearchTextFieldDelegate: AnyObject {
    func onStartEditing()
    func onTextUpdate(_ text: String)
    func onReturn(_ text: String)
    func onShowFilters()
}

final class SearchTextField: UITextField {

    weak var searchDelegate: SearchTextFieldDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        delegate = self
        layer.cornerRadius = 10
        layer.masksToBounds = true
        autocorrectionType = .no
        textColor = .black
        font = .systemFont(ofSize: 16)
        backgroundColor = .systemGray5
        placeholder = "Search"
        translatesAutoresizingMaskIntoConstraints = false
        setupLeftRightView(position: .left, symbol: Constants.glass)
        setupLeftRightView(position: .right, symbol: Constants.filter)
    }

    private func setupLeftRightView(position: ViewPosition, symbol: UIImage) {
        let view = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: Constants.leftRightViewWidth,
                height: frame.height)
        )
        let symbolImageView = UIImageView(
            frame: CGRect(
                x: position == .left ? Constants.leftRightViewPadding : 0,
                y: 0,
                width: Constants.leftRightViewSymbolImageViewWidth,
                height: frame.height
            )
        )

        if position == .right {
            let tapGesture = UITapGestureRecognizer(
                target: self,
                action: #selector(didTapFilter)
            )
            view.addGestureRecognizer(tapGesture)
        }

        symbolImageView.image = symbol
        symbolImageView.contentMode = .center
        view.addSubview(symbolImageView)

        switch position {
        case .left:
            leftView = view
            leftViewMode = .always

        case .right:
            rightView = view
            rightViewMode = .always
        }
    }

    @objc
    private func didTapFilter() {
        searchDelegate?.onShowFilters()
    }
}

extension SearchTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        searchDelegate?.onReturn(text ?? "")
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchDelegate?.onStartEditing()
    }

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let searchText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        searchDelegate?.onTextUpdate(searchText)
        return true
    }
}

private enum Constants {
    static let leftRightViewPadding: CGFloat = 15
    static let leftRightViewSymbolImageViewWidth: CGFloat = 30
    static let leftRightViewWidth: CGFloat =
    leftRightViewPadding + leftRightViewSymbolImageViewWidth
    static let leftSymbolScale: CGFloat = 1.25

    // swiftlint:disable force_unwrapping
    static let glass = UIImage.systemImageWithColor(name: "magnifyingglass", color: .lightGray)!
    static let filter = UIImage.systemImageWithColor(name: "slider.horizontal.3", color: .black)!
    // swiftlint:enable force_unwrapping
}

private enum ViewPosition {
    case left
    case right
}
