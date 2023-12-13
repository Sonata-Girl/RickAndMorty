//
//  EpisodeModel.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 13.12.2023.
//

import Foundation

// MARK: - Welcome
struct EpisodeDto: Decodable {
    let info: Info
    let results: [Result]
}

// MARK: - Info
struct Info: Decodable {
    let count, pages: Int
    let next: String
//    let prev: JSONNull?
}

// MARK: - Result
struct Result: Decodable {
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

