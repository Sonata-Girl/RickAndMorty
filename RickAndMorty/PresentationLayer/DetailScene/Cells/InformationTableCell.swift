//
//  InformationTableCell.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 17.12.2023.
//

import UIKit

final class InformationTableCell: UITableViewHeaderFooterView {
    
    // MARK: UI
    
    let title: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray2
        label.text = "Informations"
        label.font = UIFont.robotoMedium(size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Init
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupHierarchy()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Override methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = nil
    }
}

// MARK: - Setup Hierarchy

private extension InformationTableCell {
    func setupHierarchy() {
        contentView.addSubview(title)
    }
}

// MARK: - Setup Layout

private extension InformationTableCell {
    func setupLayout() {
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            title.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 10
            ),
            trailingAnchor.constraint(
                equalTo: title.trailingAnchor,
                constant: 20
            )
        ])
    }
}

extension InformationTableCell {
    static var identifier: String {
        String(describing: self)
    }
}
