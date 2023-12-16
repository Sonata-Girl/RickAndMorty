//
//  EpisodeModel.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 13.12.2023.
//

import Foundation

// MARK: - Episode model

struct EpisodeModel: Hashable, Identifiable {
    let id: Int
    let episodeUrl: URL?
    let episodeNumber: String
    var characterUrl: URL
    var character: CharacterModel?
    var isFavorite: Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: EpisodeModel, rhs: EpisodeModel) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Convert from dto method

extension EpisodeModel {
    init(from dto: EpisodeDto){
        self.id = dto.id
        self.episodeUrl = dto.url
        self.episodeNumber = "\(dto.name) | \(dto.episode)"
        self.isFavorite = false
        self.characterUrl = dto.character
        self.character = nil
    }
}

//extension EpisodeModel {
//    init(from cache: CacheEpisodeWrapper){
//        self.id = cache.id
//        self.episodeUrl = cache.episodeUrl
//        self.episodeNumber = cache.episodeNumber
//        self.isFavorite = cache.isFavorite
//        self.characterUrl = cache.characterUrl
//        if let characterWrapped = cache.character {
//            self.character = CharacterModel(from: characterWrapped)
//        }
//    }
//}

// MARK: - Date convert methods
typealias EpisodeModels = [EpisodeModel]
