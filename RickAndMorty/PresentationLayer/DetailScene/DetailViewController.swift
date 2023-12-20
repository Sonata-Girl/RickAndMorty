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
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 5
        imageView.layer.cornerRadius = 75
        imageView.layer.borderColor = UIColor.systemGray5.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var changePhotoButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "camera"), for: .normal)
        button.tintColor = .label
        button.addTarget(nil, action: #selector(changePhotoTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var characterNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 30)
        label.textColor = .label
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var detailCharacterTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false // отключение возможности выбора
        tableView.register(
            DetailViewCell.self,
            forCellReuseIdentifier: DetailViewCell.identifier
        )
        tableView.register(
            InformationTableCell.self,
            forHeaderFooterViewReuseIdentifier: InformationTableCell.identifier
        )
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
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
    
    @objc private func changePhotoTapped() {
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
            mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])
        
        NSLayoutConstraint.activate([
            characterImageView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            characterImageView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            characterImageView.heightAnchor.constraint(equalTo: mainView.heightAnchor, multiplier: 0.6),
            characterImageView.widthAnchor.constraint(equalTo: characterImageView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            changePhotoButton.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            changePhotoButton.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 5),
        ])
        
        
        NSLayoutConstraint.activate([
            characterNameLabel.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            characterNameLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            detailCharacterTableView.topAnchor.constraint(equalTo: mainView.bottomAnchor),
            detailCharacterTableView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Constants.indentFromSuperView / 2
            ),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(
                equalTo: detailCharacterTableView.trailingAnchor,
                constant: Constants.indentFromSuperView
            ),
            detailCharacterTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
        
        navigationItem.leftBarButtonItem?.image = UIImage(systemName: "BackButton")
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
            ["Gender": characterModel.gender],
            ["Status": characterModel.status],
            ["Type": characterModel.type],
            ["Origin": characterModel.origin],
            ["Location": characterModel.location]]
        
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
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: InformationTableCell.identifier) as? InformationTableCell else { return InformationTableCell() }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        65
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Constants.headerHeight
    }
}

// MARK: - Constants

private enum Constants {
    static var indentFromSuperView: CGFloat = 30
    static var headerLabelFrame: CGFloat = 5
    static var headerHeight: CGFloat = 50
}
