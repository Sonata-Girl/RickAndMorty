//
//  ViewController.swift
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
        
//        presenter?.getJobs()
    }

    private func saveUserSettings() {
        guard let presenter else { return }
//        presenter.saveSelectedCells(selectedCells: getReservedJobs())
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
//        view.addSubview(reserveView)
//        reserveView.addSubview(reserveButton)
    }
}

// MARK: - Setup layouts for UI

private extension MainViewController {
    func setupLayout() {
        NSLayoutConstraint.activate([
            episodesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            episodesCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            episodesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
//        NSLayoutConstraint.activate([
//            reserveView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            reserveView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            reserveView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            reserveView.heightAnchor.constraint(equalToConstant: Constants.cellHeight)
//        ])
        
//        NSLayoutConstraint.activate([
//            reserveButton.topAnchor.constraint(
//                equalTo: reserveView.topAnchor,
//                constant: Constants.indentFromSuperView
//            ),
//            reserveButton.leadingAnchor.constraint(
//                equalTo: reserveView.leadingAnchor,
//                constant: Constants.indentFromSuperView
//            ),
//            view.safeAreaLayoutGuide.trailingAnchor.constraint(
//                equalTo: reserveButton.trailingAnchor,
//                constant: Constants.indentFromSuperView
//            ),
//            reserveButton.heightAnchor.constraint(equalTo: reserveView.heightAnchor, multiplier: 0.4)
//        ])
    }
}

// MARK: - Configure navigation controller

private extension MainViewController {
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

private extension MainViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(Constants.cellHeight)
        )

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(Constants.cellHeight)
        )
        let layoutGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [layoutItem]
        )
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.contentInsets = .init(
            top: Constants.layoutSectionInset,
            leading: Constants.layoutSectionInset,
            bottom: Constants.cellHeight,
            trailing: Constants.layoutSectionInset
        )
        layoutSection.interGroupSpacing = Constants.layoutSectionInset
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

extension MainViewController: UICollectionViewDelegate {
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

extension MainViewController: MainViewProtocol {
    func episodesLoaded() {
//        guard let presenter else { return }
//        createDataSnapshot( items: presenter.jobs)
    }
    
    func imageLoaded() {
        DispatchQueue.main.async {
            self.updateDataSnapshot()
        }
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
}

// MARK: - Handle actions methods

private extension MainViewController {
    
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
    
    static var defaultReserveButtonTitle = "Выберите подработки"
}


