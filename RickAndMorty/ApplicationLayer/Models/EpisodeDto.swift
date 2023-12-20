//
//  EpisodeModel.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 13.12.2023.
//

import Foundation

// MARK: - Welcome
struct EpisodesDto: Decodable {
    let info: PageInfo
    let results: [EpisodeDto]
}

// MARK: - Info
struct PageInfo: Decodable {
    let count, pages: Int
    let next: URL?
    let prev: URL?
    
    init(from pageInfo: PageInfo) {
        self.count = pageInfo.count
        self.pages = pageInfo.pages
        self.next = pageInfo.next
        self.prev = pageInfo.prev
    }
}

// MARK: - Result
struct EpisodeDto: Decodable {
    let id: Int
    let name, airDate, episode: String
    let characters: [URL]
    let url: URL
    let created: String
    var character: URL {
        characters.randomElement() ?? characters[0]
    }
}

// MARK: - Convert JobDto to JobsModel methods

extension EpisodeDto {
    var model: EpisodeModel {
        .init(from: self)
    }
}

extension Array where Element == EpisodeDto {
    var models: EpisodeModels {
        self.map { $0.model }
    }
}

typealias EpisodeDtoModels = [EpisodeDto]
