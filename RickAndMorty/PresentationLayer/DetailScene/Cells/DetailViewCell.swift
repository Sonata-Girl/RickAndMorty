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
        label.font = .systemFont(
            ofSize: 15,
            weight: .light
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(
            ofSize: 15,
            weight: .regular
        )
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
    
    required init?(coder: NSCoder) {
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
            propertyLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            propertyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            propertyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            propertyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: propertyLabel.bottomAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: - Configure cell values

extension DetailViewCell {
    func configureCell(key: String, value: String) {
        propertyLabel.text = key
        valueLabel.text = value
    }
    
    override func prepareForReuse() {
        propertyLabel.text = nil
        valueLabel.text = nil
    }
}

// MARK: - Identifier cell

extension DetailViewCell {
    static var identifier: String {
        String(describing: self)
    }
}
