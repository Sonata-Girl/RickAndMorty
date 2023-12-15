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
    func characterLoaded()
    func failure(error: Error)
}

// MARK: - Presenter protocol

protocol MainPresenterProtocol: AnyObject {
    init(view: MainViewProtocol,
         networkManager: NetworkServiceProtocol,
         router: RouterProtocol
    )
    var pageInfo: PageInfo? { get set }
    var episodes: EpisodeModels { get set }
    var filteredEpisodes: EpisodeModels  { get set }
    func getEpisodes()
    func subloadEpisodes()
    func getCharacter(characterUrl: URL, episodeIndex: Int)
    func loadCharacterImage(characterImageUrl: URL, indexItem: Int)
    //    func saveSelectedCells(selectedCells: EpisodeModels)
}

// MARK: - Presenter

final class MainViewPresenter: MainPresenterProtocol {
    weak var view: MainViewProtocol?
    let networkManager: NetworkServiceProtocol?
    var router: RouterProtocol?
    var episodes: EpisodeModels = []
    var filteredEpisodes: EpisodeModels = []
    var pageNumber = 1
    var pageInfo: PageInfo?
 
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
        networkManager?.getEpisodes(page: pageNumber) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result {
                    case .success(let episodesDto):
                        pageInfo = PageInfo(from: episodesDto.info)
                        self.episodes += episodesDto.results.models
                        //                        self.loadSelectedCellsSettings()
                        self.view?.episodesLoaded()
                    case .failure(let error):
                        self.view?.failure(error: error)
                }
            }
        }
    }
    
    func subloadEpisodes() {
        pageNumber += 1
        getEpisodes()
    }
    
    func getCharacter(characterUrl: URL, episodeIndex: Int) {
        networkManager?.getCharacter(characterUrl: characterUrl) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result {
                    case .success(let characterDto):
                        self.episodes[episodeIndex].character = characterDto.model
                        loadCharacterImage(characterImageUrl: characterDto.model.imageUrl, indexItem: episodeIndex)
                    case .failure(let error):
                        self.view?.failure(error: error)
                }
            }
        }
    }
    
    func loadCharacterImage(characterImageUrl: URL, indexItem: Int) {
        networkManager?.loadImageData(from: characterImageUrl) { [weak self] result in
            guard let self,
                  let imageData = result else { return }
            self.episodes[indexItem].character?.imageData = imageData
            self.view?.characterLoaded()
        }
    }
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
