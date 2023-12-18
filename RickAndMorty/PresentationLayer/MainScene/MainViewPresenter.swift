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
    func createCollection()
    func updateCollection()
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
    func deleteCell(at index: Int)
}

// MARK: - Presenter

final class MainViewPresenter: MainPresenterProtocol {
    weak var view: MainViewProtocol?
    let networkManager: NetworkServiceProtocol?
    let router: RouterProtocol?
    var episodes: EpisodeModels = []
    var filteredEpisodes: EpisodeModels = []
    var pageNumber = 1
    var isSubloading = false
    var pageInfo: PageInfo?
    private let cacheCharacter = NSCache<NSString, CacheCharacterWrapper>()
    var favoriteCells = Set<Int>()
    
    required init(
        view: MainViewProtocol,
        networkManager: NetworkServiceProtocol,
        router: RouterProtocol
    ) {
        self.view = view
        self.networkManager = networkManager
        self.router = router
        loadUserSaves()
    }

    // MARK: Loading data method
    
    func getEpisodes(subload: Bool = false) {
        networkManager?.getEpisodes(page: pageNumber) { [weak self] result in
            guard let self else { return }
            switch result {
                case .success(let episodesDto):
                    self.pageInfo = PageInfo(from: episodesDto.info)
                    self.episodes += episodesDto.results.models.map {
                        var episodeModel = $0
                        if self.favoriteCells.contains($0.id) {
                            episodeModel.isFavorite.toggle()
                        }
                        return episodeModel
                    }
                    self.view?.createCollection()
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
            self.view?.updateCollection()
            return
        }
        networkManager?.getCharacter(characterUrl: characterUrl) { [weak self] result in
            guard let self else { return }
            switch result {
                case .success(let characterDto):
                    self.episodes[episodeIndex].character = characterDto.model
                    loadCharacterImage(
                        characterImageUrl: characterDto.model.imageUrl,
                        indexItem: episodeIndex
                    )
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
                self.cacheCharacter.setObject(
                    characterModelWrapped,
                    forKey: character.url.absoluteString as NSString
                )
            }
            self.view?.updateCollection()
        }
    }
    
    // MARK: Change data methods
    
    func didSelectFavoriteCell(at indexCell: Int) {
        episodes[indexCell].isFavorite.toggle()
        let episode = episodes[indexCell]
        if episode.isFavorite {
            favoriteCells.insert(episode.id)
        } else {
            favoriteCells.remove(episode.id)
        }
        
        saveSelectedCells()
        view?.updateCollection()
    }
    
    func characterImageTapped(at indexCell: Int) {
        guard let character = self.episodes[indexCell].character else { return }
        router?.showDetailViewController(characterModel: character)
    }
    
    func deleteCell(at index: Int) {
        episodes.remove(at: index)
        view?.createCollection()
    }

    // MARK: UserDefaults methods
    
    private func loadUserSaves() {
        guard let userFavoriteCells = UserDefaults.standard.value(
            forKey: Constants.userFavoritesSavesName
        ) as? [Int] else { return }
        
        favoriteCells = Set(userFavoriteCells)
    }
    
    func saveSelectedCells() {
        UserDefaults.standard.set(
            Array(favoriteCells),
            forKey: Constants.userFavoritesSavesName
        )
    }
}

// MARK: - Constants

private enum Constants {
    static var userFavoritesSavesName = "userFavoritesSavesName"
}
