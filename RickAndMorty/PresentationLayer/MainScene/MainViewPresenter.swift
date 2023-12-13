//
//  MainViewPresenter.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 13.12.2023.
//
//

import Foundation

// MARK: - View protocol

protocol MainViewProtocol: AnyObject {
    func episodesLoaded()
    func imageLoaded()
    func failure(error: Error)
}

// MARK: - Presenter protocol

protocol MainPresenterProtocol: AnyObject {
    init(view: MainViewProtocol,
         networkManager: NetworkServiceProtocol,
         router: RouterProtocol
    )
    var episodes: EpisodeModels { get set }
    var filteredEpisodes: EpisodeModels  { get set }
    func getEpisodes()
    //    func loadImage(jobModel: EpisodeModel, indexItem: Int)
    //    func saveSelectedCells(selectedCells: EpisodeModels)
}

// MARK: - Presenter

final class MainViewPresenter: MainPresenterProtocol {
    weak var view: MainViewProtocol?
    let networkManager: NetworkServiceProtocol?
    var router: RouterProtocol?
    var episodes: EpisodeModels = []
    var filteredEpisodes: EpisodeModels = []
    //        var savedSelectedCells = SelectedCellsSavingModel()
    
    required init(
        view: MainViewProtocol,
        networkManager: NetworkServiceProtocol,
        router: RouterProtocol
    ) {
        self.view = view
        self.networkManager = networkManager
        self.router = router
        //            loadUserSaves()
    }
    
    // MARK: Loading data methods
    
    func getEpisodes() {
        networkManager?.getEpisodes() { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                    case .success(let episodes):
                        self.episodes += episodes.models
                        //                        self.loadSelectedCellsSettings()
                        self.view?.episodesLoaded()
                    case .failure(let error):
                        self.view?.failure(error: error)
                }
            }
        }
    }
    
    //    func loadImage(jobModel: JobModel, indexItem: Int) {
    //        guard let logoUrl = jobModel.logo else { return }
    //        networkManager?.loadImageData(from: logoUrl) { [weak self] result in
    //            guard let self,
    //                  let imageData = result else { return }
    //            DispatchQueue.main.async {
    //                self.jobs[indexItem].logoData = imageData
    //                self.view?.imageLoaded()
    //            }
    //        }
    //    }
    
    // MARK: UserDefaults methods
    
    private func loadUserSaves() {
        //        guard let userSelectedCells = UserDefaults.standard.value(
        //            SelectedCellsSavingModel.self,
        //            forKey: Constants.userSavesSelectedCellsName
        //        ) else { return }
        //
        //        savedSelectedCells = userSelectedCells
    }
    
    private func loadSelectedCellsSettings() {
        //        guard savedSelectedCells.isEmpty == false else { return }
        //
        //        savedSelectedCells.forEach { savedCell in
        //            if let indexJob = jobs.firstIndex(where: {
        //                $0.profession == savedCell.profession &&
        //                $0.employer == savedCell.employer &&
        //                $0.salary == savedCell.salary &&
        //                $0.id == savedCell.id
        //            }) {
        //                jobs[indexJob].isSelected = true
        //            }
        //        }
    }
    
    //    func saveSelectedCells(selectedCells: JobsModel) {
    //        savedSelectedCells = SelectedCellsSavingModel()
    //        selectedCells.forEach {
    //            self.savedSelectedCells.append(SelectedCellSavingModel(jobModel: $0))
    //        }
    //        UserDefaults.standard.set(
    //            encodable: self.savedSelectedCells,
    //            forKey: Constants.userSavesSelectedCellsName
    //        )
    //    }
}

// MARK: - Constants

private enum Constants {
    static var userSavesSelectedCellsName = "userSavesSelectedCells"
}
