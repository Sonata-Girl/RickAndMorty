//
//  LaunchViewController.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 12.12.2023.
//

import UIKit

protocol LaunchViewProtocol {
    func startAnimate(with duration: Int)
}

final class LaunchViewController: UIViewController {
    
    // MARK: UI elements
    
    private let appNameLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "NameLogo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
 
        return imageView
    }()
    
     let launchLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "LoadingLogo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - View controller lifecycle methods
   
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        additionSubviews()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - Configure view properties

private extension LaunchViewController {
    func configureView() {
        view.backgroundColor = .white
    }
}

// MARK: - Setup view

private extension LaunchViewController {
    func additionSubviews() {
        view.addSubview(appNameLogo)
        view.addSubview(launchLogo)
    }
}

// MARK: - Setup layouts for UI

private extension LaunchViewController {
    func setupLayout() {
        NSLayoutConstraint.activate([
            appNameLogo.topAnchor.constraint(
                lessThanOrEqualTo: view.topAnchor,
                constant: 120
            ),
            appNameLogo.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Constants.indentXFromSuperView
            ),
            view.trailingAnchor.constraint(
                equalTo: appNameLogo.trailingAnchor,
                constant: Constants.indentXFromSuperView
            ),
            appNameLogo.heightAnchor.constraint(equalToConstant: 105),
        ])
        
        NSLayoutConstraint.activate([
            launchLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            launchLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            launchLogo.widthAnchor.constraint(equalToConstant: Constants.loadLogoSize),
            launchLogo.heightAnchor.constraint(equalToConstant: Constants.loadLogoSize),
        ])
    }
}

extension LaunchViewController: LaunchViewProtocol {
    func startAnimate(with duration: Int) {
        UIView.animate(withDuration: TimeInterval(duration)) {
            self.launchLogo.transform = CGAffineTransform(rotationAngle: .pi)
            self.launchLogo.transform = CGAffineTransform(rotationAngle: .pi * 2)
        }
    }
}

// MARK: - Constants

private enum Constants {
    static var indentXFromSuperView: CGFloat = 34
    static let loadLogoSize: CGFloat = 300
}
