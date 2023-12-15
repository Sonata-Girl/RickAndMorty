//
//  EpisodeViewCell.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 12.12.2023.
//

import UIKit

final class EpisodeCell: UICollectionViewCell {
    
    // MARK: UI elements
    
    private let mainView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.lightCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let characterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = Constants.characterLogoDefault
        imageView.layer.cornerRadius = Constants.lightCornerRadius
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let characterNameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.mediumFont
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Bottom subview
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.1)
        view.layer.cornerRadius = Constants.mediumCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let playLabel: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "play")
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let episodeNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = Constants.lightFont
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let favoriteImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = Constants.favoriteLogoDefault
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        additionSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setDefaultStateCell()
    }
}
// MARK: - Configure view

private extension EpisodeCell {
    func configureView() {
        backgroundColor = .white
    }
    
    func setDefaultStateCell() {
        layer.cornerRadius = Constants.lightCornerRadius
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 2
        layer.shadowColor = UIColor.black.withAlphaComponent(0.7).cgColor
        layer.shadowOpacity = 0.5
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds.insetBy(dx: -1, dy: -1),
            cornerRadius: Constants.lightCornerRadius
        ).cgPath
    }
}

// MARK: - Setup Hierarchy

private extension EpisodeCell {
    func additionSubviews() {
        contentView.addSubview(mainView)
        mainView.addSubview(characterImage)
        mainView.addSubview(characterNameLabel)
        mainView.addSubview(bottomView)
        
        bottomView.addSubview(playLabel)
        bottomView.addSubview(episodeNumberLabel)
        bottomView.addSubview(favoriteImage)
    }
}

// MARK: - Setup constraints

private extension EpisodeCell {
    func setupLayout() {
    
        // MARK: Main view constraints
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            characterImage.topAnchor.constraint(equalTo: mainView.topAnchor),
            characterImage.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            characterImage.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            characterImage.heightAnchor.constraint(equalToConstant: bounds.height / 1.5)
        ])
        
        NSLayoutConstraint.activate([
            characterNameLabel.topAnchor.constraint(equalTo: characterImage.bottomAnchor),
            characterNameLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: Constants.mediumSpacingItems),
            mainView.trailingAnchor.constraint(equalTo: characterNameLabel.trailingAnchor, constant: Constants.mediumSpacingItems),
         ])
        
        // MARK: Bottom subview constraints
      
        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: characterNameLabel.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor),
            bottomView.heightAnchor.constraint(equalTo: mainView.heightAnchor, multiplier: 0.2)
          ])
        
        NSLayoutConstraint.activate([
            playLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: Constants.mediumSpacingItems),
            playLabel.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            playLabel.widthAnchor.constraint(equalToConstant: Constants.smallSizeBottomUI),
            playLabel.heightAnchor.constraint(equalToConstant: Constants.smallSizeBottomUI),
        ])
        
        NSLayoutConstraint.activate([
            episodeNumberLabel.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            episodeNumberLabel.leadingAnchor.constraint(
                equalTo: playLabel.trailingAnchor,
                constant: Constants.lightSpacingItems
            )
        ])

        NSLayoutConstraint.activate([
            favoriteImage.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            favoriteImage.leadingAnchor.constraint(
                equalTo: episodeNumberLabel.trailingAnchor,
                constant: Constants.lightSpacingItems
            ),
            bottomView.trailingAnchor.constraint(
                equalTo: favoriteImage.trailingAnchor,
                constant: Constants.mediumSpacingItems
            ),
            favoriteImage.widthAnchor.constraint(equalToConstant: Constants.mediumSizeBottomUI),
            favoriteImage.heightAnchor.constraint(equalToConstant: Constants.mediumSizeBottomUI),
        ])
    }
}

// MARK: - Configure cell values

extension EpisodeCell {
    func configureCell(episodeModel: EpisodeModel) {
        characterNameLabel.text = episodeModel.character?.name
        episodeNumberLabel.text = episodeModel.episodeNumber
       
        if let imageData = episodeModel.character?.imageData {
            characterImage.image = UIImage(data: imageData)
            characterImage.contentMode = .scaleAspectFill
        }
        #warning("Clean")
//        if let data = try? Data(contentsOf: episodeModel.character?.imageUrl ?? URL(fileURLWithPath: "")) {
//            characterImage.image = UIImage(data: data)
//        }
        
        changeSelectedCellState(selected: episodeModel.isFavorite)
    }
    
    func changeSelectedCellState(selected: Bool) {
        favoriteImage.image = selected ? UIImage(named: "favoriteSelect") : Constants.favoriteLogoDefault
    }

    override func prepareForReuse() {
        characterNameLabel.text = nil
        episodeNumberLabel.text = nil
        characterImage.image = Constants.characterLogoDefault
        favoriteImage.image = Constants.favoriteLogoDefault
        characterImage.contentMode = .scaleAspectFit
    }
    
}

// MARK: - Identifier cell

extension EpisodeCell {
    static var identifier: String {
        String(describing: self)
    }
}

// MARK: - Constants

private enum Constants {
    static var lightCornerRadius: CGFloat = 6
    static var mediumCornerRadius: CGFloat = 15
    
    static var smallSizeBottomUI: CGFloat = 40
    static var mediumSizeBottomUI: CGFloat = 45
    
    static var lightSpacingItems: CGFloat = 5
    static var mediumSpacingItems: CGFloat = 20
    
    static var smallFont: UIFont = .systemFont(ofSize: 15)
    static var lightFont: UIFont = .systemFont(
        ofSize: 20,
        weight: .light
    )
   static var regularFont: UIFont = .systemFont(
        ofSize: 20,
        weight: .regular
    )
    static var mediumFont: UIFont = .systemFont(
        ofSize: 20,
        weight: .medium
    )
    
    static var characterLogoDefault = UIImage(named: "NameLogo")
    static var favoriteLogoDefault = UIImage(named: "favorite")
}
