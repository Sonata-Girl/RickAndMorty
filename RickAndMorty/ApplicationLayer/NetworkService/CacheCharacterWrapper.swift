//
//  CacheCharacterWrapper.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 16.12.2023.
//

import Foundation

class CacheCharacterWrapper {
    let id: Int
    let name: String
    let gender: String
    let status: String
    let type: String
    let origin: String
    let location: String
    let imageUrl: URL
    let imageData: Data?
 
    init(from model: CharacterModel) {
        self.id = model.id
        self.name = model.name
        self.gender = model.gender
        self.status = model.status
        self.type = model.type
        self.origin = model.origin
        self.location = model.location
        self.imageUrl = model.imageUrl
        self.imageData = model.imageData
    }
}
