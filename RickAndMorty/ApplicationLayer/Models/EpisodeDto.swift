//
//  EpisodeModel.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 13.12.2023.
//

import Foundation

// MARK: - Welcome
struct EpisodesDto: Decodable {
    let info: Info
    let results: [EpisodeDto]
}

// MARK: - Info
struct Info: Decodable {
    let count, pages: Int
    let next: String
//    let prev: JSONNull?
}

// MARK: - Result
struct EpisodeDto: Decodable {
    let id: Int
    let name, airDate, episode: String
    let characters: [String]
    let url: String
    let created: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case airDate = "air_date"
        case episode, characters, url, created
    }
}

// MARK: - Convert JobDto to JobsModel methods

extension EpisodeDto {
    var model: EpisodeModel {
        .init(from: self, logoData: nil)
    }
}

extension Array where Element == EpisodeDto {
    var models: EpisodeModels {
        self.map { $0.model }
    }
}

typealias EpisodeDtoModels = [EpisodeDto]
