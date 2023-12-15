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
    let episodeImageUrl: URL?
    var isFavorite: Bool
    let episodeNumber: String
    var characterUrl: URL
    var character: CharacterModel?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: EpisodeModel, rhs: EpisodeModel) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Convert from dto method

extension EpisodeModel {
    init(from dto: EpisodeDto
//         episodeImageData: Data?
//         characterModel: CharacterModel
    ){
        self.id = dto.id
        self.episodeImageUrl = dto.url
        self.episodeNumber = "\(dto.name) | \(dto.episode)"
        self.isFavorite = false
        self.characterUrl = dto.character
        self.character = nil
    }
}

// MARK: - Date convert methods
typealias EpisodeModels = [EpisodeModel]
