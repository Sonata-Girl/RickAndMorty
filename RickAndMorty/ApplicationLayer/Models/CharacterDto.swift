//
//  CharacterDto.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 14.12.2023.
//

import Foundation

// MARK: - Character

struct CharacterDto: Decodable {
    let id: Int
    let name: String
    let gender: String
    let status: String
    let type: String
    let origin: Name
    let location: Name
    let image: URL
    let url: URL
}


// MARK: - Origin Location
struct Name: Decodable {
    let name: String
}

extension CharacterDto {
    var model: CharacterModel {
        .init(from: self)
    }
}

extension Array where Element == CharacterDto {
    var models: CharacterModels {
        self.map { $0.model }
    }
}
