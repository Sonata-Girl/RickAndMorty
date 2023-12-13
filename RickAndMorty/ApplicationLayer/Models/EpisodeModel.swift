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
//    let logo: URL?
//    let profession: String
//    let employer: String
//    let salary: Double
//    let date: String
//    var isSelected: Bool
//    var logoData: Data?
   
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: EpisodeModel, rhs: EpisodeModel) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Convert from dto method

extension EpisodeModel {
    init(from dto: EpisodeDto, logoData: Data?) {
        self.id = dto.id
//        self.logo = dto.logo
//        self.profession = dto.profession
//        self.employer = dto.employer
//        self.salary = dto.salary
//        self.date = dto.date
//        self.logoData = logoData
//        self.isSelected = false
    }
}

// MARK: - Date convert methods
typealias EpisodeModels = [EpisodeModel]
