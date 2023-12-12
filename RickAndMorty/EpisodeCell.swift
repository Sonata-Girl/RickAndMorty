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
        let label = PaddingLabel()
         label.font = Constants.mediumFont
        label.textColor = .label
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Bottom subview
    
    private let bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray.withAlphaComponent(0.3)
        view.layer.cornerRadius = Constants.lightCornerRadius
        return view
    }()
    
    private let playLabel: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "play")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .black
        return imageView
    }()
    
    private let episodeNumberLabel: UILabel = {
        let label = PaddingLabel()
        label.textColor = .label
        label.clipsToBounds = true
        label.textAlignment = .center
        label.font = Constants.semiboldFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let favoriteImage: UIImageView = {
       let imageView = UIImageView()
       imageView.contentMode = .scaleAspectFit
       imageView.clipsToBounds = true
       imageView.image = UIImage(named: "favorite")
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
        let quarterSizeWidthCell = bounds.width/3.8
        
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
            episodeImage.heightAnchor.constraint(equalToConstant: quarterSizeWidthCell)
        ])
        
        NSLayoutConstraint.activate([
            characterNameLabel.topAnchor.constraint(equalTo: episodeImage.bottomAnchor),
            characterNameLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: Constants.smallSpacingItems),
            mainView.trailingAnchor.constraint(equalTo: characterNameLabel.trailingAnchor, constant: Constants.smallSpacingItems),
            characterNameLabel.heightAnchor.constraint(equalToConstant: 55)
         ])
        
        // MARK: Bottom subview constraints
      
        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: characterNameLabel.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: Constants.smallSpacingItems),
            mainView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: Constants.smallSpacingItems),
            mainView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: Constants.smallSpacingItems),
          ])
        
        
        NSLayoutConstraint.activate([
//            playLabel.topAnchor.constraint(
//                equalTo: bottomView.topAnchor,
//                constant: Constants.smallSpacingItems
//            ),
            playLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: Constants.smallSpacingItems),
            bottomView.centerYAnchor.constraint(equalTo: playLabel.centerYAnchor),
            playLabel.widthAnchor.constraint(equalToConstant: 32),
            playLabel.heightAnchor.constraint(equalToConstant: 32),
        ])
        
        NSLayoutConstraint.activate([
            episodeNumberLabel.topAnchor.constraint(equalTo: bottomView.topAnchor),
            episodeNumberLabel.leadingAnchor.constraint(
                equalTo: playLabel.rightAnchor,
                constant: Constants.smallSpacingItems
            ),
            episodeNumberLabel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            favoriteImage.topAnchor.constraint(equalTo: bottomView.topAnchor),
            favoriteImage.leadingAnchor.constraint(
                equalTo: playLabel.rightAnchor,
                constant: Constants.smallSpacingItems
            ),
            bottomView.trailingAnchor.constraint(
                equalTo: favoriteImage.trailingAnchor,
                constant: Constants.smallSpacingItems
            ),
            bottomView.bottomAnchor.constraint(
                equalTo: favoriteImage.bottomAnchor,
                constant: Constants.smallSpacingItems
            ),
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
    
    static var indentFromSuperView: CGFloat = 20
    static var mediumSpacingItems: CGFloat = 15
    static var smallSpacingItems: CGFloat = 10
    
    static var heightOfCellParts: CGFloat = 52
    
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
    static var rubSymbol = "₽"
}
