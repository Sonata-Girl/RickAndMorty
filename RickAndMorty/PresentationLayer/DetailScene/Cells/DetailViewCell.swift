//
//  DetailViewCell.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 16.12.2023.
//

import UIKit

final class DetailViewCell: UITableViewCell {
    
    // MARK: UI elements
    
    private let propertyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont(name: "Roboto-Medium", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont(name: "Roboto-Light", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Init
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        additionSubviews()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure cell

private extension DetailViewCell {
    func configureView() {
        backgroundColor = .white
    }
}

// MARK: - Setup Hierarchy

private extension DetailViewCell {
    func additionSubviews() {
        contentView.addSubview(propertyLabel)
        contentView.addSubview(valueLabel)
    }
}

// MARK: - Setup constraints

private extension DetailViewCell {
    func setupLayout() {
        NSLayoutConstraint.activate([
            propertyLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 5
            ),
            propertyLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.indentFromSuperView
            ),
            contentView.trailingAnchor.constraint(
                equalTo: propertyLabel.trailingAnchor,
                constant: Constants.indentFromSuperView
            ),
        ])
        
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: propertyLabel.bottomAnchor),
            valueLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.indentFromSuperView
            ),
            contentView.trailingAnchor.constraint(
                equalTo: valueLabel.trailingAnchor,
                constant: Constants.indentFromSuperView
            ),
            contentView.bottomAnchor.constraint(
                equalTo: valueLabel.bottomAnchor,
                constant: 10
            )
        ])
    }
}

// MARK: - Configure cell values

extension DetailViewCell {
    func configureCell(key: String, value: String) {
        propertyLabel.text = key
        valueLabel.text = value == "" ? "Unknown" : value.localizedCapitalized
    }
    
    override func prepareForReuse() {
        propertyLabel.text = nil
        valueLabel.text = nil
    }
}

// MARK: - Constants

private enum Constants {
    static var indentFromSuperView: CGFloat = 20
}

// MARK: - Identifier cell

extension DetailViewCell {
    static var identifier: String {
        String(describing: self)
    }
}
