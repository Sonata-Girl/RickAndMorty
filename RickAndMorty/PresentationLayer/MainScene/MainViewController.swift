//
//  MainViewController.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 12.12.2023.
//

import UIKit

enum SearchType {
    case name, episode, all
}

final class MainViewController: UIViewController {
    
    // MARK: Properties
    
    var presenter: MainPresenterProtocol?
    private var dataSource: UICollectionViewDiffableDataSource<SectionLayoutKind, EpisodeModel>?
    
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    private var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    private var searchBy: SearchType?
    
    // MARK: UI elements
    
    private lazy var searchBarRightConstraint: NSLayoutConstraint = {
        let constraint = searchController.searchBar.trailingAnchor.constraint(
            equalTo: searchController.searchBar.searchTextField.trailingAnchor,
            constant: Constants.mediumInset
        )
        return constraint
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.searchTextField.borderStyle = .none
        searchController.searchBar.barTintColor = UIColor.white
        searchController.searchBar.searchTextField.font = UIFont.robotoThin(size: 20)
        searchController.searchBar.placeholder = "Name or episode (ex.S01E01)..."
        searchController.searchBar.searchTextField.layer.borderColor = UIColor.gray.cgColor
        searchController.searchBar.searchTextField.layer.borderWidth = 1
        searchController.searchBar.searchTextField.layer.cornerRadius = Constants.lightCornerRadius
        searchController.searchBar.searchTextField.frame.size.height = 50
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.delegate = self
        searchController.searchBar.searchTextField.translatesAutoresizingMaskIntoConstraints = false
        return searchController
    }()
    
    private var logoImageView: UIImageView = {
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
        collectionView.register(
            HeaderEpisodes.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderEpisodes.identifier
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
        navigationController?.navigationBar.addSubview(logoImageView)
    }
}

// MARK: - Setup layouts for UI

private extension MainViewController {
    func setupLayout() {
        let navigationBar = navigationController?.navigationBar ?? UINavigationBar()
        NSLayoutConstraint.activate([
            logoImageView.leftAnchor.constraint(
                equalTo: navigationBar.leftAnchor,
                constant: Constants.mediumInset
            ),
            navigationBar.rightAnchor.constraint(
                equalTo: logoImageView.rightAnchor,
                constant: Constants.mediumInset
            ),
            logoImageView.heightAnchor.constraint(
                equalTo: navigationBar.heightAnchor,
                multiplier: 0.4
            )
        ])
        
        NSLayoutConstraint.activate([
            searchController.searchBar.searchTextField.leadingAnchor.constraint(
                equalTo: searchController.searchBar.leadingAnchor,
                constant: Constants.mediumInset
            ),
            searchBarRightConstraint,
            searchController.searchBar.searchTextField.heightAnchor.constraint(
                equalTo: searchController.searchBar.heightAnchor,
                multiplier: 1
            )
        ])
        
        NSLayoutConstraint.activate([
            episodesCollectionView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 10
            ),
            episodesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            episodesCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            episodesCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
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
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
   
    func filterContentForSearchText(_ searchText: String) {
        guard let presenter else { return }
       
        if isSearchBarEmpty {
            presenter.clearFilter()
        } else {
            presenter.filterEpisodes(searchBy: searchBy, searchText: searchText)
        }
    }
}

// MARK: - Search methods

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text else { return }
        filterContentForSearchText(filter)
    }
}

extension MainViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        searchBarRightConstraint.constant = 80
        view.layoutIfNeeded()
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        searchBarRightConstraint.constant = Constants.mediumInset
        view.layoutIfNeeded()
    }
}

// MARK: - Collection layout methods

private extension MainViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layoutSection = CustomLayoutSection.shared.create(showHeader: true)
        return UICollectionViewCompositionalLayout(section: layoutSection)
    }
}

// MARK: - Collection DataSource setup

private extension MainViewController {
    enum SectionLayoutKind: Int, CaseIterable {
        case main
    }
    
    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SectionLayoutKind, EpisodeModel>(collectionView: episodesCollectionView) { [weak self]
            (collectionView: UICollectionView, indexPath: IndexPath, item: EpisodeModel) -> UICollectionViewCell? in
            guard let self,
                let presenter = self.presenter,
                let cell = episodesCollectionView.dequeueReusableCell(
                withReuseIdentifier: EpisodeCell.identifier,
                for: indexPath
            ) as? EpisodeCell else { return EpisodeCell() }
            
            let episodes = self.isFiltering ? presenter.filteredEpisodes : presenter.episodes
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
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
             // Создание и настройка представления дополнительного элемента
            let sectionLayoutKind = SectionLayoutKind.allCases[indexPath.section]
            
            switch sectionLayoutKind {
            case .main:
                guard let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: HeaderEpisodes.identifier,
                    for: indexPath
                ) as? HeaderEpisodes
                else { return UICollectionReusableView() }
                
                header.delegate = self
                return header
            } 
        }

    }
    
    func createDataSnapshot(episodes: EpisodeModels) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, EpisodeModel>()
        snapshot.appendSections([.main])
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
        
        if !presenter.isSubloading && !isFiltering {
            presenter.startSubloadEpisodes()
        }
    }
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
        let indexPath = IndexPath(item: indexCell, section: 0)
        guard let cell = episodesCollectionView.cellForItem(at: indexPath) as? EpisodeCell else { return }
        cell.returnStateOfFavoriteImage()
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
}

// MARK: - Handle actions methods

extension MainViewController: EpisodeCellDelegate {
    func selectFavoriteCell(at indexCell: Int) {
        presenter?.didSelectFavoriteCell(at: indexCell)
    }
    
    func characterImageTapped(at indexCell: Int) {
        presenter?.characterImageTapped(at: indexCell)
    }
     
    func deleteCell(at indexCell: Int) {
        presenter?.deleteCell(at: indexCell)
    }
}

// MARK: - Handle actions methods

extension MainViewController: HeaderEpisodesDelegate {
    func filterButtonTapped(searchType: SearchType) {
        searchBy = searchType
        var textPlaceHolder = ""
        switch searchBy {
            case .all, .none: textPlaceHolder = "Name or episode (ex.S01E01)..."
            case .episode: textPlaceHolder = "Episode (ex.S01E01)..."
            case .name: textPlaceHolder = "Name (ex.Rick)..."
        }
        searchController.searchBar.placeholder = textPlaceHolder
    }
}

// MARK: - Constants

private enum Constants {
    static var lightCornerRadius: CGFloat = 6
    
    static var mediumInset: CGFloat = 20
    static var lightInset: CGFloat = 10
    static var thinInset: CGFloat = 5
    
    static var lightBlueColor = UIColor(
        _colorLiteralRed: 227/255,
        green: 242/255,
        blue: 253/255,
        alpha: 1
    )
}
