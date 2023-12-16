//
//  DetailViewController.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 13.12.2023.
//

import UIKit

final class DetailViewController: UIViewController {
    
    // MARK: Properties
    
    var character: CharacterModel?
    var presenter: DetailViewPresenter?
    var characterProperties: [[String: String]] = []
    
    // MARK: UIElements
    
    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var changePhotoButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "camera"), for: .normal)
        button.tintColor = .label
//        button.addTarget(nil, action: #selector(changePhotoTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var characterNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var detailCharacterTableView: UITableView = {
        let tableView = UITableView()
        //        tableView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        tableView.layer.cornerRadius = 30
        //        tableView.layer.borderWidth = 2
        tableView.layer.masksToBounds = true
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false // отключение возможности выбора
        tableView.register(DetailViewCell.self, forCellReuseIdentifier: DetailViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    // MARK: - View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        additionSubviews()
        setupLayout()
        configureNavigationController()
        
        presenter?.configureCharacterDetail()
    }
    
    private func saveUserSettings() {
        guard let presenter else { return }
        //        presenter.saveSelectedCells(selectedCells: getReservedJobs())
    }
}

// MARK: - Configure view properties

private extension DetailViewController {
    func configureView() {
        view.backgroundColor = .white
    }
}

// MARK: - Setup view

private extension DetailViewController {
    func additionSubviews() {
        view.addSubview(mainView)
        mainView.addSubview(characterImageView)
        mainView.addSubview(changePhotoButton)
        mainView.addSubview(characterNameLabel)
        view.addSubview(detailCharacterTableView)
    }
}

// MARK: - Setup layouts for UI

private extension DetailViewController {
    func setupLayout() {
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            characterImageView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            characterImageView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
//            characterImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            characterImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            characterImageView.heightAnchor.constraint(equalTo: mainView.heightAnchor, multiplier: 0.5),
            characterImageView.widthAnchor.constraint(equalTo: characterImageView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
//            changePhotoButton.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            changePhotoButton.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            changePhotoButton.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 5),
//            changePhotoButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            changePhotoButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            detailCharacterTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            detailCharacterTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            detailCharacterTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            detailCharacterTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

// MARK: - Configure navigation controller

private extension DetailViewController {
    func configureNavigationController() {
        setupNavigationBarButtons()
    }
    
    private func setupNavigationBarButtons() {
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "BackButton"),
            style: .plain, 
            target: self,
            action: #selector(backButtonTapped)
        )
        
        let navBarImage = UIBarButtonItem(
            image: UIImage(systemName: "NavBarImage"),
            style: .plain,
            target: nil,
            action: nil
        )
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = navBarImage
    }
    
    @objc private func backButtonTapped() {
        presenter?.backButtonTapped()
    }
}

// MARK: - Loading data method

extension DetailViewController: DetailViewProtocol {
    func configureCharacterDetail(characterModel: CharacterModel) {
        if let imageData = characterModel.imageData {
            characterImageView.image = UIImage(data: imageData)
        }
        characterNameLabel.text = characterModel.name
        character = characterModel
        
        characterProperties = [
            ["gender": characterModel.gender],
            ["status": characterModel.status],
            ["type": characterModel.type],
            ["origin": characterModel.origin],
            ["location": characterModel.location]]
        
    }
}
    
// MARK: - UITableViewDelegate UITableViewDataSource

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        characterProperties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailViewCell.identifier, for: indexPath) as? DetailViewCell else { return UITableViewCell() }
        
        let property = characterProperties[indexPath.row]
        let key = property.keys.first ?? ""
        let value = property.values.first ?? ""

        cell.configureCell(key: key, value: value)
        return cell
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}

// MARK: - Constants

private enum Constants {
    static var indentFromSuperView: CGFloat = 20
    static var layoutSectionInset: CGFloat = 10
    static let cellHeight: CGFloat = 105
}


