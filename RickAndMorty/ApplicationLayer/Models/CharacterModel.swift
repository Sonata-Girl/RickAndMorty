//
//  CharacterModel.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 14.12.2023.
//

import Foundation

// MARK: - Character model

struct CharacterModel: Hashable, Identifiable {
    let id: Int
    let name: String
    let gender: String
    let status: String
    let type: String
    let origin: String
    let location: String
    let imageUrl: URL
    var imageData: Data?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: CharacterDto, rhs: CharacterModel) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Convert from dto method

extension CharacterModel {
    init(from dto: CharacterDto) {
        self.id = dto.id
        self.name = dto.name
        self.gender = dto.gender
        self.status = dto.status
        self.type = dto.type
        self.origin = dto.origin.name
        self.location = dto.location.name
        self.imageUrl = dto.image
        self.imageData = nil
    }
}

// MARK: - Date convert methods
typealias CharacterModels = [CharacterModel]
