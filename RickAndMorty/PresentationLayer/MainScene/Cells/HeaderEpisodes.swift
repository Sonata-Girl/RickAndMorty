//
//  HeaderEpisodes.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 21.12.2023.
//

import UIKit

protocol HeaderEpisodesDelegate: AnyObject {
    func filterButtonTapped(searchType: SearchType)
}

final class HeaderEpisodes: UICollectionReusableView {
    
    weak var delegate: HeaderEpisodesDelegate?

    // MARK: UI
    private lazy var filtersButton: UIButton = {
        let button = UIButton()
        button.setTitle("ADVANCED FILTERS", for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 15)
        button.setImage(UIImage(named: "Filter"), for: .normal)
        button.backgroundColor = Constants.lightBlueColor
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.cornerRadius = Constants.lightCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Override methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func filterButtonTapped(searchType: SearchType) {
        delegate?.filterButtonTapped(searchType: searchType)
    }
}

// MARK: - Configure view

private extension HeaderEpisodes {
    func configureView() {
        backgroundColor = .white
        layer.cornerRadius = Constants.lightCornerRadius
       
        addShadow()
        
        let sortedByName = UIAction(title: "by Character name") { _ in
            self.filterButtonTapped(searchType: .name)
        }
        let sortedByEpisode = UIAction(title: "by Episode") { _ in
            self.filterButtonTapped(searchType: .episode)
        }
        
        filtersButton.menu = UIMenu(children: [sortedByName, sortedByEpisode])
    }
}

// MARK: - Setup Hierarchy

private extension HeaderEpisodes {
    func setupHierarchy() {
         addSubview(filtersButton)
    }
}

// MARK: - Setup Layout

private extension HeaderEpisodes {
    func setupLayout() {
        NSLayoutConstraint.activate([
            filtersButton.topAnchor.constraint(equalTo: topAnchor),
            filtersButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            filtersButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            filtersButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: - Identifier header

extension HeaderEpisodes {
    static var identifier: String {
        String(describing: self)
    }
}

// MARK: - Constants

private enum Constants {
    static var lightCornerRadius: CGFloat = 6
    
    static var lightBlueColor = UIColor(
        _colorLiteralRed: 227/255,
        green: 242/255,
        blue: 253/255,
        alpha: 1
    )
}
