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
    func createCollection(episodes: EpisodeModels)
    func updateCollection(episodes: EpisodeModels)
    func deleteItem(episodes: EpisodeModels)
    func endAnimationOfFavoriteButton(indexCell: Int)
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
   
    func filterEpisodes(searchBy: SearchType?, searchText: String)
    func didSelectFavoriteCell(at idEpisode: Int)
    func characterImageTapped(at idEpisode: Int)
    func deleteCell(at idEpisode: Int)
    func loadFavoriteCells()
    func clearFilter()
    
}

// MARK: - Presenter

final class MainViewPresenter: MainPresenterProtocol {
    weak var view: MainViewProtocol?
    let networkManager: NetworkServiceProtocol?
    let router: RouterProtocol?
    private let cacheCharacter = NSCache<NSString, CacheCharacterWrapper>()
    
    var episodes: EpisodeModels = []
    var filteredEpisodes: EpisodeModels = []
    var filteredText: String = ""
    var filterType: SearchType? = .all
    var favoriteEpisodes = Set<Int>()
    
    var pageNumber = 1
    var isSubloading = false
    var pageInfo: PageInfo?
    
    required init(
        view: MainViewProtocol,
        networkManager: NetworkServiceProtocol,
        router: RouterProtocol
    ) {
        self.view = view
        self.networkManager = networkManager
        self.router = router
        loadFavoritesFromFile()
    }

    // MARK: Loading data methods
    
    func getEpisodes(subload: Bool = false) {
        networkManager?.getEpisodes(page: pageNumber) { [weak self] result in
            guard let self else { return }
            switch result {
                case .success(let episodesDto):
                    self.pageInfo = PageInfo(from: episodesDto.info)
                    self.episodes += episodesDto.results.models.map {
                        var episodeModel = $0
                        if self.favoriteEpisodes.contains($0.id) {
                            episodeModel.isFavorite = true
                        }
                        return episodeModel
                    }
                    if filteredText.isEmpty {
                        print(#function, "filter is empty")
                       self.view?.createCollection(episodes: self.episodes)
                    } else {
                        print(#function, "filter not empty")
                        filterEpisodes(searchBy: filterType, searchText: filteredText)
                    }
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
    
    // MARK: GET character
    
    func getCharacter(characterUrl: URL, episodeIndex: Int) {
        guard let indexEpisode = episodes.indices.contains(episodeIndex) ? episodeIndex : nil else { return }
        if let cachedCharacter = cacheCharacter.object(forKey: characterUrl.absoluteString as NSString) {
            episodes[indexEpisode].character = CharacterModel(from: cachedCharacter)
            
            if filteredText.isEmpty {
                print(#function, "filter is empty")
                view?.updateCollection(episodes: episodes)
            } else {
                print(#function, "filter not empty")
                filterEpisodes(searchBy: filterType, searchText: filteredText)
            }
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
           if filteredText.isEmpty {
                print(#function, "filter is empty")
                self.view?.updateCollection(episodes: episodes)
            } else {
                print(#function, "filter not empty")
                filterEpisodes(searchBy: filterType, searchText: filteredText)
            }
        }
    }
    
    // MARK: Change data methods
    
    func filterEpisodes(searchBy: SearchType?, searchText: String) {
        filteredText = searchText
        filterType = searchBy
        filteredEpisodes = episodes.filter { episodeModel in
            switch searchBy {
                case .episode :
                    return episodeModel.episodeNumber.lowercased().contains(searchText.lowercased())
                case .name :
                    guard let characterName = episodeModel.character?.name else { return false }
                    return characterName.lowercased().contains(searchText.lowercased())
                case .all, .none :
                    var nameSearch = false
                    if let characterName = episodeModel.character?.name {
                        nameSearch = characterName.lowercased().contains(searchText.lowercased())
                    }
                    return episodeModel.episodeNumber.lowercased().contains(searchText.lowercased()) || nameSearch
            }
        
        }
        print(#function)
        view?.createCollection(episodes: filteredEpisodes)
    }
    
    func clearFilter() {
        filteredText = ""
        filterType = .all
        filteredEpisodes.removeAll()
        print(#function)
        view?.createCollection(episodes: episodes)
    }
    
    func didSelectFavoriteCell(at indexCell: Int) {
        episodes[indexCell].isFavorite.toggle()
        
        if episodes[indexCell].isFavorite {
            favoriteEpisodes.insert(episodes[indexCell].id)
        } else {
            favoriteEpisodes.remove(episodes[indexCell].id)
        }
        saveFavoritesToFile()
        
        if filteredText.isEmpty {
            print(#function, "filter is empty")
            view?.updateCollection(episodes: episodes)
        } else {
            filteredEpisodes[indexCell].isFavorite.toggle()
            print(#function, "filter not empty")
            view?.updateCollection(episodes: filteredEpisodes)
        }
        
        view?.endAnimationOfFavoriteButton(indexCell: indexCell)
    }
    
    func characterImageTapped(at indexCell: Int) {
        guard let character = self.episodes[indexCell].character else { return }
        router?.showDetailViewController(characterModel: character)
    }
    
    func deleteCell(at indexCell: Int) {
        if filteredText.isEmpty {
            let episode = episodes.remove(at: indexCell)
            view?.deleteItem(episodes: [episode])
        } else {
            episodes.remove(at: indexCell)
            let episode = filteredEpisodes.remove(at: indexCell)
            view?.deleteItem(episodes: [episode])
        }
    }

    // MARK: Saving favorites methods
    func loadFavoriteCells() {
        loadFavoritesFromFile()
        
        episodes = episodes.map {
            var episodeModel = $0
            if self.favoriteEpisodes.contains($0.id) {
                episodeModel.isFavorite = true
            } else {
                episodeModel.isFavorite = false
            }
            return episodeModel
        }
        if filteredEpisodes.isEmpty {
            print(#function, "filter is empty")
           self.view?.updateCollection(episodes: episodes)
        } else {
            filteredEpisodes = filteredEpisodes.map {
                var episodeModel = $0
                if self.favoriteEpisodes.contains($0.id) {
                    episodeModel.isFavorite = true
                } else {
                    episodeModel.isFavorite = false
                }
                return episodeModel
            }
            print(#function, "filter not empty")
           self.view?.updateCollection(episodes: filteredEpisodes)
        }
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
                print("load in main file")
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
