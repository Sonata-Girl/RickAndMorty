//
//  FavoritesViewPresenter.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 13.12.2023.
//

import Foundation

// MARK: - View protocol

protocol FavoritesViewProtocol: AnyObject {
    func createCollection(episodes: EpisodeModels)
    func updateCollection(episodes: EpisodeModels)
    func deleteItem(episodes: EpisodeModels)
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
    func didSelectFavoriteCell(at idEpisode: Int)
    func characterImageTapped(at idEpisode: Int)
    func loadFavoriteCells()
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
        loadFavoritesFromFile()
    }
    
    // MARK: Loading data methods
    
    func getEpisodes() {
        let episodesStrings = favoriteEpisodes.map{String($0)}
        switch favoriteEpisodes.count {
            case .zero :
                view?.createCollection(episodes: self.episodes)
                return
            case 1 :
                getEpisode(episodesStrings: episodesStrings)
            default :
                getMultipleEpisodes(episodesStrings: episodesStrings)
        }
    }
    
    // MARK: GET multiple episodes
    
    func getMultipleEpisodes(episodesStrings: [String]) {
        networkManager?.getMultipleEpisodes(episodesStrings: episodesStrings) { [weak self] result in
            guard let self else { return }
            switch result {
                case .success(let episodesDto):
                    self.episodes = episodesDto.models.map {
                        var episodeModel = $0
                        if self.favoriteEpisodes.contains($0.id) {
                            episodeModel.isFavorite = true
                        }
                        return episodeModel
                    }
                    self.view?.createCollection(episodes: self.episodes)
                case .failure(let error):
                    self.view?.failure(error: error)
            }
        }
    }
    
    // MARK: GET one episode
    
    func getEpisode(episodesStrings: [String]) {
        networkManager?.getEpisode(episodesStrings: episodesStrings) { [weak self] result in
            guard let self else { return }
            switch result {
                case .success(let episodesDto):
                    self.episodes = episodesDto.models.map {
                        var episodeModel = $0
                        if self.favoriteEpisodes.contains($0.id) {
                            episodeModel.isFavorite = true
                        }
                        return episodeModel
                    }
                    self.view?.createCollection(episodes: self.episodes)
                case .failure(let error):
                    self.view?.failure(error: error)
            }
        }
    }
    
    // MARK: GET character
   
    func getCharacter(characterUrl: URL, episodeIndex: Int) {
        guard let indexEpisode = episodes.indices.contains(episodeIndex) ? episodeIndex : nil else { return }
        if let cachedCharacter = cacheCharacter.object(forKey: characterUrl.absoluteString as NSString) {
            episodes[indexEpisode].character = CharacterModel(from: cachedCharacter)
            view?.updateCollection(episodes: episodes)
            return
        }
        networkManager?.getCharacter(characterUrl: characterUrl) { [weak self] result in
            guard let self else { return }
            switch result {
                case .success(let characterDto):
                    self.episodes[indexEpisode].character = characterDto.model
                    loadCharacterImage(
                        characterImageUrl: characterDto.model.imageUrl,
                        indexItem: indexEpisode
                    )
                case .failure(let error):
                    self.view?.failure(error: error)
            }
            
        }
    }
    
    // MARK: GET character image
   
    func loadCharacterImage(characterImageUrl: URL, indexItem: Int) {
        guard let indexEpisode = episodes.indices.contains(indexItem) ? indexItem : nil else { return }
        networkManager?.loadImageData(from: characterImageUrl) { [weak self] result in
            guard let self,
                  let imageData = result else { return }
            self.episodes[indexEpisode].character?.imageData = imageData
            if let character = self.episodes[indexItem].character {
                let characterModelWrapped = CacheCharacterWrapper(from: character)
                self.cacheCharacter.setObject(
                    characterModelWrapped,
                    forKey: character.url.absoluteString as NSString
                )
            }
            self.view?.updateCollection(episodes: episodes)
        }
    }
    
    // MARK: Change data methods
    
    func didSelectFavoriteCell(at indexCell: Int) {
        episodes[indexCell].isFavorite.toggle()
        
        let episode = episodes.remove(at: indexCell)
        if episode.isFavorite {
            favoriteEpisodes.insert(episode.id)
        } else {
            favoriteEpisodes.remove(episode.id)
        }
        
        saveFavoritesToFile()
        view?.deleteItem(episodes: [episode])
    }
    
    func characterImageTapped(at indexCell: Int) {
        guard let character = self.episodes[indexCell].character else { return }
        router?.showDetailViewController(characterModel: character)
    }
    
    // MARK: Saving favorites methods
    

    func loadFavoriteCells() {
        loadFavoritesFromFile()
        getEpisodes()
    }
    
    func saveFavoritesToFile() {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileName = Constants.userFavoritesSavesName
        let fileURL = documentsDirectory.appendingPathComponent(fileName) // добавляет имя (уид)файла к пути
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old file")
            } catch let error {
                print("couldn't remove file with error", error)
            }
        }
        
        do {
            let arrayString = favoriteEpisodes.map(String.init).joined(separator: "\n")
            try arrayString.write(toFile: fileURL.path, atomically: true, encoding: .utf8)
            print("saved file")
        } catch let error {
            print("error saving file with error", error)
        }
    }
    
    func loadFavoritesFromFile() {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
            let arrayString = documentsDirectory.appendingPathComponent(Constants.userFavoritesSavesName)
            do {
                let content = try String(contentsOfFile: arrayString.path, encoding: .utf8)
                favoriteEpisodes = Set(content.components(separatedBy: "\n").compactMap(Int.init))
                print("load file")
            } catch let error {
                print("error loading file with error", error)
            }
        }
    }
}

// MARK: - Constants

private enum Constants {
    static var userFavoritesSavesName = "userFavoritesSavesName"
}
