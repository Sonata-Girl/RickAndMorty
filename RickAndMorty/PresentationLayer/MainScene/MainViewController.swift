//
//  MainViewController.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 12.12.2023.
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: Properties
    
    var presenter: MainPresenterProtocol?
    private var dataSource: UICollectionViewDiffableDataSource<Int, EpisodeModel>?
    
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    private var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    // MARK: UI elements
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.searchTextField.borderStyle = .none
        searchController.searchBar.barTintColor = UIColor.white
        searchController.searchBar.searchTextField.font = UIFont(name: "Roboto-Thin", size: 20)
        searchController.searchBar.placeholder = "Name or episode (ex.S01E01)..."
        searchController.searchBar.searchTextField.layer.borderColor = UIColor.gray.cgColor
        searchController.searchBar.searchTextField.layer.borderWidth = 1
        searchController.searchBar.searchTextField.layer.cornerRadius = 8
        searchController.searchBar.searchTextField.frame.size.height = 50
        searchController.searchBar.searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchController
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "NameLogo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var episodesCollectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            EpisodeCell.self,
            forCellWithReuseIdentifier: EpisodeCell.identifier
        )
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        additionSubviews()
        setupLayout()
        configureNavigationController()
        setupDataSource()
        
        presenter?.getEpisodes(subload: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.loadFavoriteCells()
    }
}

// MARK: - Configure view properties

private extension MainViewController {
    func configureView() {
        view.backgroundColor = .white
    }
}

// MARK: - Setup view

private extension MainViewController {
    func additionSubviews() {
        view.addSubview(episodesCollectionView)
        navigationController?.navigationBar.addSubview(imageView)
    }
}

// MARK: - Setup layouts for UI

private extension MainViewController {
    func setupLayout() {
        NSLayoutConstraint.activate([
            searchController.searchBar.searchTextField.leadingAnchor.constraint(
                equalTo: searchController.searchBar.leadingAnchor,
                constant: 20
            ),
            searchController.searchBar.trailingAnchor.constraint(
                equalTo: searchController.searchBar.searchTextField.trailingAnchor,
                constant: 20
            ),
            searchController.searchBar.searchTextField.heightAnchor.constraint(
                equalTo: searchController.searchBar.heightAnchor,
                multiplier: 1
            )
        ])
        
        NSLayoutConstraint.activate([
            episodesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            episodesCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            episodesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
 
extension MainViewController: UISearchBarDelegate {
    
//    searc
}

// MARK: - Configure navigation controller

private extension MainViewController {
    func configureNavigationController() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        
        setupLayoutNavigationBar()
    }
    
    func setupLayoutNavigationBar() {
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.prefersLargeTitles = true
            NSLayoutConstraint.activate([
                imageView.leftAnchor.constraint(
                    equalTo: navigationBar.leftAnchor,
                    constant: 10
                ),
                navigationBar.rightAnchor.constraint(
                    equalTo: imageView.rightAnchor,
                    constant: 10
                ),
                imageView.heightAnchor.constraint(
                    equalTo: navigationBar.heightAnchor,
                    multiplier: 0.6
                )
            ])
        }
    }
    
//    func filterContentForSearchText(_ searchText: String) {
//        guard let presenter else { return }
//       
//        presenter.filteredJobs = presenter.jobs.filter { jobModel in
//            if isSearchBarEmpty {
//                return false
//            } else {
//                return jobModel.employer.lowercased().contains(searchText.lowercased()) || jobModel.profession.lowercased().contains(searchText.lowercased())
//            }
//        }
//        if isSearchBarEmpty {
//            createDataSnapshot(items: presenter.jobs)
//        } else {
//            createDataSnapshot(items: presenter.filteredJobs)
//        }
//    }
}

// MARK: - Search methods

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text else { return }
//        filterContentForSearchText(filter)
    }
}

// MARK: - Collection layout methods

private extension MainViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layoutSection = CustomLayoutSection.shared.create()
        return UICollectionViewCompositionalLayout(section: layoutSection)
    }
}

// MARK: - Collection DataSource setup

private extension MainViewController {
    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, EpisodeModel>(collectionView: episodesCollectionView) { [weak self]
            (collectionView: UICollectionView, indexPath: IndexPath, item: EpisodeModel) -> UICollectionViewCell? in
            guard let self,
                let presenter = self.presenter,
                let cell = episodesCollectionView.dequeueReusableCell(
                withReuseIdentifier: EpisodeCell.identifier,
                for: indexPath
            ) as? EpisodeCell else { return EpisodeCell() }
            
            #warning("clear")
//            let jobs = self.isFiltering ? presenter.filteredJobs : presenter.jobs
            let episodes = presenter.episodes
            let item = episodes[indexPath.item]
            
            if item.character == nil {
                presenter.getCharacter(
                    characterUrl: item.characterUrl,
                    episodeIndex: indexPath.item
                )
            }
            
            cell.delegate = self
            cell.configureCell(episodeModel: item)
            return cell
        }
        
    }
    
    func createDataSnapshot(episodes: EpisodeModels) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, EpisodeModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(episodes)
        dataSource?.apply(
            snapshot,
            animatingDifferences: false
        )
    }
    
    func updateDataSnapshot(episodes: EpisodeModels) {
        guard var updatedSnapshot = dataSource?.snapshot() else { return }
        if isSearchBarEmpty {
            updatedSnapshot.reloadItems(episodes)
        } else {
            updatedSnapshot.reloadItems(episodes)
        }
        self.dataSource?.apply(
            updatedSnapshot,
            animatingDifferences: false
        )
    }
    
    func deleteItemFromDataSnapshot(episodes: EpisodeModels) {
        guard var updatedSnapshot = dataSource?.snapshot() else { return }
        updatedSnapshot.deleteItems(episodes)
        dataSource?.apply(
            updatedSnapshot,
            animatingDifferences: true
        )
    }
}

// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastItem = collectionView.numberOfItems(inSection: 0) - 1
        guard indexPath.item == lastItem else { return }

        guard 
            let presenter = presenter,
            let _ = presenter.pageInfo?.next
        else { return }
        
        if !presenter.isSubloading {
            presenter.startSubloadEpisodes()
        }
    }
    
//    func getReservedJobs() -> EpisodeModels {
//        guard let jobs = presenter?.jobs else { return JobsModel() }
//        return jobs.filter { $0.isSelected }
//    }
}

// MARK: - Loading data with network service

extension MainViewController: MainViewProtocol {
    func createCollection(episodes: EpisodeModels) {
        DispatchQueue.main.async {
            self.createDataSnapshot(episodes: episodes)
        }
    }
    
    func updateCollection(episodes: EpisodeModels) {
        DispatchQueue.main.async {
            self.updateDataSnapshot(episodes: episodes)
        }
    }
    
    func deleteItem(episodes: EpisodeModels) {
        DispatchQueue.main.async {
            self.deleteItemFromDataSnapshot(episodes: episodes)
        }
    }
    
    func endAnimationOfFavoriteButton(indexCell: Int) {
         let indexPath = IndexPath(row: indexCell, section: 0)
        guard let cell = episodesCollectionView.cellForItem(at: indexPath) as? EpisodeCell else { return }
        cell.returnStateOfFavoriteImage()
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
}

// MARK: - Handle actions methods

extension MainViewController: EpisodeCellDelegate {
    func selectFavoriteCell(at idEpisode: Int) {
        presenter?.didSelectFavoriteCell(at: idEpisode)
    }
    
    func characterImageTapped(at idEpisode: Int) {
        presenter?.characterImageTapped(at: idEpisode)
    }
     
    func deleteCell(at idEpisode: Int) {
        presenter?.deleteCell(at:idEpisode)
    }
}
