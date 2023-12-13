//
//  FavoritesVCBuilder.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 13.12.2023.
//

import UIKit

protocol FavoritesVCBuilderProtocol {
    func createFavoritesViewModule(router: RouterProtocol) -> UIViewController
}

final class FavoritesVCBuilder: FavoritesVCBuilderProtocol {
    func createFavoritesViewModule(router: RouterProtocol) -> UIViewController {
        let view = FavoritesViewController()
//        let networkService = NetworkService()
//        let presenter = MainTableViewPresenter(view: view, networkService: networkService, router: router)
//        view.presenter = presenter

        return view
    }
}
