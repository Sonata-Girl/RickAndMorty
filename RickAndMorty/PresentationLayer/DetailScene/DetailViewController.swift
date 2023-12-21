//
//  DetailViewController.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 13.12.2023.
//

import UIKit
import PhotosUI

final class DetailViewController: UIViewController {
    
    // MARK: Properties
    
    var character: CharacterModel?
    var presenter: DetailViewPresenter?
    var characterProperties: [[String: String]] = []
    private lazy var imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        return imagePickerController
    }()
    
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
    
    private lazy var changePhotoButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "camera"), for: .normal)
        button.tintColor = .label
        button.addTarget(
            self,
            action: #selector(changePhotoTapped),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var characterNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.robotoRegular(size: 30)
        label.textColor = .label
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var detailCharacterTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
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
        requestPlacePhotoFrom()
    }
    
    private func requestPlacePhotoFrom() {
        let alertController = UIAlertController(
            title: "Загрузите изображение",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let actionCamera = UIAlertAction(title: "Камера", style: .default) { [weak self] (action)  in
            guard let self else {return}
            PhotoAccessCenter.checkCameraAuthentication(in: self) {
                self.openCamera()
            }
        }
        let actionGallery = UIAlertAction(title: "Галерея", style: .default) {  [weak self] (action) in
            guard let self else {return}
            PhotoAccessCenter.checkLibraryAuthentication(in: self) {
                self.openGallery()
            }
        }
        let cancel = UIAlertAction(title: "Отмена", style: .cancel) { (action) in
            
        }
        
        alertController.addAction(actionCamera)
        alertController.addAction(actionGallery)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
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
            mainView.heightAnchor.constraint(
                equalTo: view.heightAnchor,
                multiplier: 0.3
            )
        ])
        
        NSLayoutConstraint.activate([
            characterImageView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            characterImageView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            characterImageView.heightAnchor.constraint(
                equalTo: mainView.heightAnchor,
                multiplier: 0.6
            ),
            characterImageView.widthAnchor.constraint(equalTo: characterImageView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            changePhotoButton.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            changePhotoButton.leadingAnchor.constraint(
                equalTo: characterImageView.trailingAnchor,
                constant: 5
            ),
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
        navigationController?.navigationBar.prefersLargeTitles = false
        setupNavigationBarButtons()
    }
    
    private func setupNavigationBarButtons() {
        let backButtonView = UIButton()
        backButtonView.setImage(UIImage(named: "BackButton"), for: .normal)
        backButtonView.addTarget(
            self,
            action: #selector(backButtonTapped),
            for: .touchUpInside
        )
        let backButton = UIBarButtonItem(customView: backButtonView)
        navigationItem.leftBarButtonItem = backButton

        let charactersView = UIImageView(image: UIImage(named: "NavBarImage"))
        let characterButton = UIBarButtonItem(customView: charactersView)
        navigationItem.rightBarButtonItem = characterButton
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

// MARK: - Gallery delegate mathods

extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func openCamera() {
        imagePickerController.sourceType = .camera
        
        imagePickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera) ?? []
        imagePickerController.mediaTypes = ["public.image"]
        
        DispatchQueue.main.async {
            self.present(self.imagePickerController, animated: true)
        }
    }
    
    private func openGallery() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.selectionLimit = 1
        let phPickerController = PHPickerViewController.init(configuration: config)
        phPickerController.delegate = self
        self.present(phPickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let photo = info[.originalImage] as? UIImage else { return }
        
        characterImageView.image = photo
    }
}

// MARK: - Camera delegate mathods

extension DetailViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        if results.isEmpty {
            return
        }
        
       let itemProviders = results.map {$0.itemProvider}
        for (_, item) in itemProviders.enumerated() {
            
            if item.canLoadObject(ofClass: UIImage.self) {
                item.loadObject(ofClass: UIImage.self) { image, error in
                    
                    
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    
                    if let photo = image as? UIImage {
                        DispatchQueue.main.async {
                            self.characterImageView.image = photo
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Constants

private enum Constants {
    static var indentFromSuperView: CGFloat = 30
    static var headerHeight: CGFloat = 50
}
