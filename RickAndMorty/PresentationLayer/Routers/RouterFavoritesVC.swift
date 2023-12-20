//
//  RouterFavorites.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 16.12.2023.
//

import UIKit

final class RouterFavoritesVC: RouterFavoriteVCProtocol {
    var favoritesVCBuilder: FavoritesVCBuilder?
    var detailVCBuilder: DetailVCBuilder?
    var rootController: UINavigationController?

    init(favoritesVCBuilder: FavoritesVCBuilder,
         detailVCBuilder: DetailVCBuilder) {
        self.favoritesVCBuilder = favoritesVCBuilder
        self.detailVCBuilder = detailVCBuilder
        self.rootController = UINavigationController()
    }
    
    func initialFavoritesViewController() {
        guard let builder = favoritesVCBuilder else { return }
        let favoriteVC = builder.createFavoritesViewModule(router: self)
        rootController = builder.createRootController(view: favoriteVC)
    }

    func showDetailViewController(characterModel: CharacterModel) {
        if let rootController = rootController {
            guard let detailVC = detailVCBuilder?.createDetailViewModule(
                router: self,
                characterModel: characterModel
            ) else { return }
            rootController.pushViewController(detailVC, animated: true)
        }
    }
    func popToRoot() {
        if let rootController = rootController {
            rootController.popToRootViewController(animated: true)
        }
    }
}
