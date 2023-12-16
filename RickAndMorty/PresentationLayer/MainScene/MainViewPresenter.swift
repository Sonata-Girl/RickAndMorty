//
//  MainViewPresenter.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 13.12.2023.
//
//

import Foundation
import CoreData

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
    var pageInfo: PageInfo? { get }
    var episodes: EpisodeModels { get }
    var filteredEpisodes: EpisodeModels  { get }
    var isSubloading: Bool { get }
    func getEpisodes(subload: Bool)
    func startSubloadEpisodes()
    func getCharacter(characterUrl: URL, episodeIndex: Int)
    func didSelectFavoriteCell(at indexCell: Int)
    func characterImageTapped(at indexCell: Int)
    //    func saveSelectedCells(selectedCells: EpisodeModels)
}

// MARK: - Presenter

final class MainViewPresenter: MainPresenterProtocol {
    weak var view: MainViewProtocol?
    let networkManager: NetworkServiceProtocol?
    var router: RouterProtocol?
//    let context = NSPersistentContainer.viewContext
    var episodes: EpisodeModels = []
    var filteredEpisodes: EpisodeModels = []
    var pageNumber = 1
    var isSubloading = false
    var pageInfo: PageInfo?
    private let cacheCharacter = NSCache<NSString, CacheCharacterWrapper>()
    
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

    // MARK: Loading data method
    
    func getEpisodes(subload: Bool = false) {
        networkManager?.getEpisodes(page: pageNumber) { [weak self] result in
            guard let self else { return }
            switch result {
                case .success(let episodesDto):
                    self.pageInfo = PageInfo(from: episodesDto.info)
                    self.episodes += episodesDto.results.models
                    //                        self.loadSelectedCellsSettings()
                    self.view?.episodesLoaded()
                case .failure(let error):
                    self.view?.failure(error: error)
            }
        }
        isSubloading = subload
    }
    
    func startSubloadEpisodes() {
        isSubloading = true
        pageNumber += 1
        getEpisodes(subload: isSubloading)
    }
    
    func getCharacter(characterUrl: URL, episodeIndex: Int) {
        if let cachedCharacter = cacheCharacter.object(forKey: characterUrl.absoluteString as NSString) {
            self.episodes[episodeIndex].character = CharacterModel(from: cachedCharacter)
            self.view?.characterLoaded()
            return
        }
        networkManager?.getCharacter(characterUrl: characterUrl) { [weak self] result in
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
    
    func loadCharacterImage(characterImageUrl: URL, indexItem: Int) {
        networkManager?.loadImageData(from: characterImageUrl) { [weak self] result in
            guard let self,
                  let imageData = result else { return }
            self.episodes[indexItem].character?.imageData = imageData
            if let character = self.episodes[indexItem].character {
                let characterModelWrapped = CacheCharacterWrapper(from: character)
                self.cacheCharacter.setObject(characterModelWrapped, forKey: character.url.absoluteString as NSString)
            }
            self.view?.characterLoaded()
        }
    }
    
    // MARK: Change data methods
    
    func didSelectFavoriteCell(at indexCell: Int) {
        self.episodes[indexCell].isFavorite.toggle()
        #warning("todo saving in coredara?")
        
        self.view?.characterLoaded()
    }
    
    func characterImageTapped(at indexCell: Int) {
        guard let character = self.episodes[indexCell].character else { return }
        router?.showDetailViewController(characterModel: character)
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
