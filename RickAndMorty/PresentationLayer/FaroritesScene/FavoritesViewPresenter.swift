//
//  FavoritesViewPresenter.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 13.12.2023.
//

import Foundation

// MARK: - View protocol

protocol FavoritesViewProtocol: AnyObject {
    func createCollection()
    func updateCollection()
    func failure(error: Error)
}

// MARK: - Presenter protocol

protocol FavoritePresenterProtocol: AnyObject {
    init(view: FavoritesViewProtocol,
         networkManager: NetworkServiceProtocol,
         router: RouterProtocol
    )
    var episodes: EpisodeModels { get }
    func getEpisodes()
    func getCharacter(characterUrl: URL, episodeIndex: Int)
    func didSelectFavoriteCell(at indexCell: Int)
    func characterImageTapped(at indexCell: Int)
}

// MARK: - Presenter

final class FavoritesViewPresenter: FavoritePresenterProtocol {
    weak var view: FavoritesViewProtocol?
    let networkManager: NetworkServiceProtocol?
    let router: RouterProtocol?
    private let cacheCharacter = NSCache<NSString, CacheCharacterWrapper>()
   
    var episodes: EpisodeModels = []
    var favoriteEpisodes = Set<Int>()
    
    required init(
        view: FavoritesViewProtocol,
        networkManager: NetworkServiceProtocol,
        router: RouterProtocol
    ) {
        self.view = view
        self.networkManager = networkManager
        self.router = router
        loadUserSaves()
    }
    
    // MARK: Loading data method
    
    func getEpisodes() {
        let episodesStrings = favoriteEpisodes.map{String($0)}
        networkManager?.getMultipleEpisodes(episodesStrings: episodesStrings) { [weak self] result in
            guard let self else { return }
            switch result {
                case .success(let episodesDto):
                    self.episodes += episodesDto.models.map {
                        var episodeModel = $0
                        if self.favoriteEpisodes.contains($0.id) {
                            episodeModel.isFavorite.toggle()
                        }
                        return episodeModel
                    }
                    self.view?.createCollection()
                case .failure(let error):
                    self.view?.failure(error: error)
            }
        }
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
        let episode = episodes[indexCell]
        episodes.remove(at: indexCell)
        if episode.isFavorite {
            favoriteEpisodes.insert(episode.id)
        } else {
            favoriteEpisodes.remove(episode.id)
        }
        
        saveSelectedCells()
        view?.createCollection()
    }
    
    func characterImageTapped(at indexCell: Int) {
        guard let character = self.episodes[indexCell].character else { return }
        router?.showDetailViewController(characterModel: character)
    }
    
    // MARK: UserDefaults methods
    
    private func loadUserSaves() {
        guard let userFavoriteCells = UserDefaults.standard.value(
            forKey: Constants.userFavoritesSavesName
        ) as? [Int] else { return }
        
        favoriteEpisodes = Set(userFavoriteCells)
    }
    
    func saveSelectedCells() {
        UserDefaults.standard.set(
            Array(favoriteEpisodes),
            forKey: Constants.userFavoritesSavesName
        )
    }
}

// MARK: - Constants

private enum Constants {
    static var userFavoritesSavesName = "userFavoritesSavesName"
}
