//
//  EpisodeCell.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 12.12.2023.
//

import UIKit

protocol EpisodeCellDelegate: AnyObject {
    func selectFavoriteCell(at indexCell: Int)
    func characterImageTapped(at indexCell: Int)
    func deleteCell(at indexCell: Int)
}

extension EpisodeCellDelegate {
    func deleteCell(at indexCell: Int) {}
}

final class EpisodeCell: UICollectionViewCell {
    
    weak var delegate: EpisodeCellDelegate?

    // MARK: UI elements
    
    private let mainView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.lightCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var characterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = Constants.characterLogoDefault
        imageView.layer.cornerRadius = Constants.lightCornerRadius
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let oneTap = UITapGestureRecognizer(target: self, action: #selector(characterImageTapped))
        oneTap.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(oneTap)
        imageView.isUserInteractionEnabled = true
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
        imageView.image = UIImage(named: "Play")
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
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFit
        button.setImage(Constants.favoriteLogoDefault, for: .normal)
        button.addTarget(self, action: #selector(selectedFavoriteCell), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        additionSubviews()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func returnStateOfFavoriteImage() {
        animateFavoriteButton()
    }
}

// MARK: - Configure view

private extension EpisodeCell {
    func configureView() {
        backgroundColor = .white
        layer.cornerRadius = Constants.lightCornerRadius
        addShadow()
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeGesture.direction = .left
        contentView.addGestureRecognizer(swipeGesture)
    }
}

// MARK: - Cell actions

private extension EpisodeCell {
    
    func indexOfCell() -> Int? {
        let superView = superview as? UICollectionView
        guard let indexPath = superView?.collectionViewLayout.collectionView?.indexPath(for: self) else { return nil }
        return indexPath.item
    }

    @objc func selectedFavoriteCell() {
        guard let indexCell = indexOfCell() else { return }
        delegate?.selectFavoriteCell(at: indexCell)
    }
    
    @objc func characterImageTapped() {
        guard let indexCell = indexOfCell() else { return }
        delegate?.characterImageTapped(at: indexCell)
    }
    
    @objc func handleSwipe(_ gestureRecognizer: UISwipeGestureRecognizer) {        guard let indexCell = indexOfCell() else { return }
        delegate?.deleteCell(at: indexCell)
    }
    
    private func animateFavoriteButton() {
        UIView.animate(
            withDuration: 0.3,
            animations: { [weak self] in
                guard let self else { return }
                self.favoriteButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            },
            completion: { _ in UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self else { return }
                self.favoriteButton.transform = CGAffineTransform.identity
            }
        })
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
        bottomView.addSubview(favoriteButton)
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
            characterNameLabel.leadingAnchor.constraint(
                equalTo: mainView.leadingAnchor,
                constant: Constants.mediumSpacingItems
            ),
            mainView.trailingAnchor.constraint(
                equalTo: characterNameLabel.trailingAnchor,
                constant: Constants.mediumSpacingItems
            ),
         ])
        
        // MARK: Bottom subview constraints
      
        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: characterNameLabel.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor),
            bottomView.heightAnchor.constraint(
                equalTo: mainView.heightAnchor,
                multiplier: 0.2
            )
          ])
        
        NSLayoutConstraint.activate([
            playLabel.leadingAnchor.constraint(
                equalTo: bottomView.leadingAnchor,
                constant: Constants.mediumSpacingItems
            ),
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
            favoriteButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            favoriteButton.leadingAnchor.constraint(
                equalTo: episodeNumberLabel.trailingAnchor,
                constant: Constants.lightSpacingItems
            ),
            bottomView.trailingAnchor.constraint(
                equalTo: favoriteButton.trailingAnchor,
                constant: Constants.mediumSpacingItems
            ),
            favoriteButton.widthAnchor.constraint(equalToConstant: Constants.mediumSizeBottomUI),
            favoriteButton.heightAnchor.constraint(equalToConstant: Constants.mediumSizeBottomUI),
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
        changeSelectedCellState(selected: episodeModel.isFavorite)
    }
    
    func changeSelectedCellState(selected: Bool) {
        let favoriteImage = selected ? Constants.selectFavoriteLogoDefault : Constants.favoriteLogoDefault
        favoriteButton.setImage(favoriteImage, for: .normal)
    }

    override func prepareForReuse() {
        characterNameLabel.text = nil
        episodeNumberLabel.text = nil
        characterImage.image = Constants.characterLogoDefault
        changeSelectedCellState(selected: false)
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
    
    static var lightFont: UIFont = .systemFont(
        ofSize: 20,
        weight: .light
    )
    static var mediumFont = UIFont.robotoMedium(size: 20)
    
    static var characterLogoDefault = UIImage(named: "NameLogo")
    static var favoriteLogoDefault = UIImage(named: "Favorite")
    static var selectFavoriteLogoDefault = UIImage(named: "FavoriteSelect")
}
