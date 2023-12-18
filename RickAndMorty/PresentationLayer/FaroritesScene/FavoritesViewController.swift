//
//  FavoritesViewController.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 13.12.2023.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    // MARK: Properties
    
    var presenter: FavoritesViewPresenter?
    private var dataSource: UICollectionViewDiffableDataSource<Int, EpisodeModel>?
    
    // MARK: UI elements
    
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
        
        presenter?.getEpisodes()
    }
}

// MARK: - Configure view properties

private extension FavoritesViewController {
    func configureView() {
        view.backgroundColor = .white
    }
}

// MARK: - Setup view

private extension FavoritesViewController {
    func additionSubviews() {
        view.addSubview(episodesCollectionView)
    }
}

// MARK: - Setup layouts for UI

private extension FavoritesViewController {
    func setupLayout() {
        NSLayoutConstraint.activate([
            episodesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            episodesCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            episodesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - Configure navigation controller

private extension FavoritesViewController {
    func configureNavigationController() {
        navigationItem.title = "Favorites episodes"
//        navigationItem.tit
//        searchController.searchResultsUpdater = self
    }
}

// MARK: - Collection layout methods

private extension FavoritesViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layoutSection = CustomLayoutSection.shared.create()
        return UICollectionViewCompositionalLayout(section: layoutSection)
    }
}

// MARK: - Collection DataSource setup

private extension FavoritesViewController {
    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, EpisodeModel>(collectionView: episodesCollectionView) { [weak self]
            (collectionView: UICollectionView, indexPath: IndexPath, item: EpisodeModel) -> UICollectionViewCell? in
            guard let self,
                let presenter = self.presenter,
                let cell = episodesCollectionView.dequeueReusableCell(
                withReuseIdentifier: EpisodeCell.identifier,
                for: indexPath
            ) as? EpisodeCell else { return EpisodeCell() }
            
            let episodes = presenter.episodes
            let item = episodes[indexPath.item]
            
            if item.character == nil {
                presenter.getCharacter(
                    characterUrl: item.characterUrl,
                    episodeIndex: indexPath.item
                )
            }
            
            cell.delegate = self
            cell.configureCell(episodeModel: item, indexPathCell: indexPath.item)
            return cell
        }
        
    }
    
    func createDataSnapshot(items: EpisodeModels) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, EpisodeModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        dataSource?.apply(
            snapshot,
            animatingDifferences: false
        )
    }
    
    func updateDataSnapshot(withAnimation: Bool = false) {
        guard let presenter,
            var updatedSnapshot = dataSource?.snapshot() else { return }
            updatedSnapshot.reloadItems(presenter.episodes
            )
        self.dataSource?.apply(
            updatedSnapshot,
            animatingDifferences: withAnimation
        )
    }
}

// MARK: - UICollectionViewDelegate

extension FavoritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        let lastItem = collectionView.numberOfItems(inSection: 0) - 1
//        guard indexPath.item == lastItem else { return }
//
//        guard
//            let presenter = presenter,
//            let _ = presenter.pageInfo?.next
//        else { return }
//        
//        if !presenter.isSubloading {
//            presenter.startSubloadEpisodes()
//        }
    }
}

// MARK: - Loading data with network service

extension FavoritesViewController: FavoritesViewProtocol {
    func createCollection() {
        guard let presenter else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.createDataSnapshot(items: presenter.episodes)
        }
    }
    
    func updateCollection() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.updateDataSnapshot()
        }
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
}

// MARK: - Handle actions methods

extension FavoritesViewController: EpisodeCellDelegate {
    func deleteCell(at indexCell: Int) {}
    
    func selectFavoriteCell(at indexCell: Int) {
        presenter?.didSelectFavoriteCell(at: indexCell)
        let indexPath = IndexPath(row: indexCell, section: 0)
            
        guard let cell = episodesCollectionView.cellForItem(at: indexPath) as? EpisodeCell else { return }
        cell.returnStateOfFavoriteImage()
    }
    
    func characterImageTapped(at indexCell: Int) {
        presenter?.characterImageTapped(at: indexCell)
    }
}
