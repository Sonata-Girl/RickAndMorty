//
//  DetailVCBulder.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 13.12.2023.
//

import UIKit

protocol DetailVCBulderProtocol {
    func createDetailViewModule(router: RouterProtocol, characterModel: CharacterModel) -> UIViewController
}

final class DetailVCBuilder: DetailVCBulderProtocol {
    func createDetailViewModule(router: RouterProtocol, characterModel: CharacterModel) -> UIViewController {
        let view = DetailViewController()
        let networkService = NetworkService.shared
        let presenter = DetailViewPresenter(
            view: view,
            networkService: networkService,
            router: router, 
            characterModel: characterModel
        )
        view.presenter = presenter

        return view
    }
}
