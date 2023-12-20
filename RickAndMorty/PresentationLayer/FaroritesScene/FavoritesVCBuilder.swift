//
//  FavoritesVCBuilder.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 13.12.2023.
//

import UIKit

protocol FavoritesVCBuilderProtocol {
    func createFavoritesViewModule(router: RouterProtocol) -> FavoritesViewController
}

final class FavoritesVCBuilder: FavoritesVCBuilderProtocol {
    func createFavoritesViewModule(router: RouterProtocol) -> FavoritesViewController {
        let view = FavoritesViewController()
        let networkService = NetworkService.shared
        let presenter = FavoritesViewPresenter(
            view: view,
            networkManager: networkService, 
            router: router
        )
        view.presenter = presenter
        return view
    }
    
    func createRootController(view: FavoritesViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: view)
        navigationController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "Favorites"),
            selectedImage: UIImage(named: "FavoritesSelect")
        )
        return navigationController
    }
}
