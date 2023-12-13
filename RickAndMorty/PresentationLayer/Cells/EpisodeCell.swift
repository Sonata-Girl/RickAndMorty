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
    
    let episodeImage: UIImageView = {
       let imageView = UIImageView()
       imageView.contentMode = .scaleAspectFit
       imageView.clipsToBounds = true
       imageView.image = UIImage(named: "NameLogo")
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
        view.backgroundColor = .lightGray.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Constants.mediumCornerRadius
        return view
    }()
    
    private let playLabel: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "play")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let episodeNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.clipsToBounds = true
        label.font = Constants.semiboldFont
        label.backgroundColor = .orange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let favoriteImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "favorites")
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
}

// MARK: - Configure view

private extension EpisodeCell {
    func configureView() {
        backgroundColor = .white
        layer.cornerRadius = Constants.lightCornerRadius
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.12
        layer.shadowRadius = 4
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: Constants.mediumCornerRadius
        ).cgPath
    }
    
    func setDefaultStateCell() {
//        layer.shadowOpacity = 0.12
//        layer.borderWidth = 0
//        layer.borderColor = nil
//        layer.shadowColor = UIColor.black.cgColor // цвет
    }
}

// MARK: - Setup Hierarchy

private extension EpisodeCell {
    func additionSubviews() {
        contentView.addSubview(mainView)
        mainView.addSubview(episodeImage)
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
            episodeImage.topAnchor.constraint(equalTo: mainView.topAnchor),
            episodeImage.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            episodeImage.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            episodeImage.heightAnchor.constraint(equalToConstant: 230)
        ])
        
        NSLayoutConstraint.activate([
            characterNameLabel.topAnchor.constraint(equalTo: episodeImage.bottomAnchor),
            characterNameLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: Constants.mediumSpacingItems),
            mainView.trailingAnchor.constraint(equalTo: characterNameLabel.trailingAnchor, constant: Constants.mediumSpacingItems),
         ])
        
        // MARK: Bottom subview constraints
      
        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: characterNameLabel.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 70)
          ])
        
        NSLayoutConstraint.activate([
            playLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: Constants.mediumSpacingItems),
            playLabel.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            playLabel.widthAnchor.constraint(equalToConstant: 32),
            playLabel.heightAnchor.constraint(equalToConstant: 32),
        ])
        
        NSLayoutConstraint.activate([
            episodeNumberLabel.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            episodeNumberLabel.leadingAnchor.constraint(
                equalTo: playLabel.trailingAnchor,
                constant: Constants.mediumSpacingItems
            ),
//            episodeNumberLabel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor),
            playLabel.heightAnchor.constraint(equalToConstant: 32),
        ])
        
        NSLayoutConstraint.activate([
            favoriteImage.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            favoriteImage.leadingAnchor.constraint(
                equalTo: episodeNumberLabel.trailingAnchor,
                constant: Constants.mediumSpacingItems
            ),
            bottomView.trailingAnchor.constraint(
                equalTo: favoriteImage.trailingAnchor,
                constant: Constants.mediumSpacingItems
            ),
            favoriteImage.widthAnchor.constraint(equalToConstant: 32),
            favoriteImage.heightAnchor.constraint(equalToConstant: 32),
        ])
        
    }
}

// MARK: - Configure cell values

extension EpisodeCell {
//    func configureCell(jobModel: JobModel) {
//        jobNameLabel.text = jobModel.profession
//        salaryLabel.text = "\(String(format: "%.2f", jobModel.salary)) \(Constants.rubSymbol)"
//        employerLabel.text = jobModel.employer
//        dateLabel.text = jobModel.dateDay
//        timeLabel.text = jobModel.dateTime
//        
//        if let logoData = jobModel.logoData {
//            employerImageView.image = UIImage(data: logoData)
//        }
//        changeStateOfSelectedCell(selected: jobModel.isSelected)
//    }
    
//    func changeStateOfSelectedCell(selected: Bool) {
//        switch selected {
//            case true :
//                layer.borderColor = UIColor.appYellowColor().cgColor
//                layer.borderWidth = 2
//                layer.shadowColor = UIColor.appYellowColor().cgColor
//                layer.shadowOpacity = 0.6
//            case false :
//                setDefaultStateCell()
//        }
//    }
//    
//    override func prepareForReuse() {
//        jobNameLabel.text = nil
//        salaryLabel.text = nil
//        employerLabel.text = nil
//        dateLabel.text = nil
//        timeLabel.text = nil
//        employerImageView.image = UIImage(named: "noLogo")?.withRenderingMode(.alwaysTemplate)
//        setDefaultStateCell()
//    }
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
    
    static var mediumSpacingItems: CGFloat = 20
    
    static var smallFont: UIFont = .systemFont(ofSize: 15)
    static var semiboldFont: UIFont = .systemFont(
        ofSize: 20,
        weight: .semibold
    )
   static var regularFont: UIFont = .systemFont(
        ofSize: 20,
        weight: .regular
    )
    static var mediumFont: UIFont = .systemFont(
        ofSize: 20,
        weight: .medium
    )
}
