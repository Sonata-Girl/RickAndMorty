//
//  FavoritesViewController.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 13.12.2023.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    // MARK: Properties
    
    var presenter: FavoritesPresenterProtocol?
    private var dataSource: UICollectionViewDiffableDataSource<Int, EpisodeModel>?
    
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    // MARK: UI elements
    
    private var searchController: UISearchController = {
        let sc = UISearchController()
        sc.searchBar.placeholder = "Поиск"
        sc.searchBar.searchBarStyle = .minimal
        return sc
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
        //        collectionView.backgroundColor = .appLightGrayColor()
        collectionView.delegate = self
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
    
    private func saveUserSettings() {
        guard let presenter else { return }
        //        presenter.saveSelectedCells(selectedCells: getReservedJobs())
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
        //        view.addSubview(reserveView)
        //        reserveView.addSubview(reserveButton)
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
        navigationItem.searchController = searchController
        //        searchController.searchResultsUpdater = self
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

//extension MainViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let filter = searchController.searchBar.text else { return }
//        filterContentForSearchText(filter)
//    }
//}

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
            
            //            let jobs = self.isFiltering ? presenter.filteredJobs : presenter.jobs
            //            let item = jobs[indexPath.item]
            //
            //            if item.logoData == nil {
            //                presenter.loadImage(
            //                    jobModel: item,
            //                    indexItem: indexPath.item
            //                )
            //            }
            //            cell.configureCell(jobModel: item)
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
        if isSearchBarEmpty {
            //            updatedSnapshot.reloadItems(presenter.jobs)
        } else {
            //            updatedSnapshot.reloadItems(presenter.filteredJobs)
        }
        self.dataSource?.apply(
            updatedSnapshot,
            animatingDifferences: withAnimation
        )
    }
}

// MARK: - UICollectionViewDelegate

extension FavoritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        guard let presenter else { return }
        //        presenter.jobs[indexPath.item].isSelected.toggle()
        //        updateDataSnapshot()
        //        saveUserSettings()
    }
    
    
    //    func getReservedJobs() -> EpisodeModels {
    //        guard let jobs = presenter?.jobs else { return JobsModel() }
    //        return jobs.filter { $0.isSelected }
    //    }
}

// MARK: - Loading data with network service

extension FavoritesViewController: FavoritesViewProtocol {
    func favoritesLoaded() {
        guard let presenter else { return }
        createDataSnapshot( items: presenter.favorites)
    }
    
//    func imageLoaded() {
//        DispatchQueue.main.async {
//            self.updateDataSnapshot()
//        }
//    }
//    
//    func failure(error: Error) {
//        print(error.localizedDescription)
//    }
}

// MARK: - Handle actions methods

private extension FavoritesViewController {
    
    //    @objc func reserveButtonPressed() {
    //        showSumSalaryAlert()
    //    }
    //
    //    func showSumSalaryAlert() {
    //        let reservedJobs = getReservedJobs().map { $0.salary }.reduce( 0, + )
    //
    //        let message = "Вы заработали \(String(format: "%.2f", reservedJobs)) рублей"
    //        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
    //        let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
    //        alert.addAction(okAction)
    //        present(alert, animated: true)
    //    }
}

// MARK: - Constants

private enum Constants {
    static var indentFromSuperView: CGFloat = 20
    static var layoutSectionInset: CGFloat = 10
    static let cellHeight: CGFloat = 105
}


