//
//  Router.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 12.12.2023.
//

import UIKit

protocol RouterMain {
    var mainVCBuilder: MainVCBuilder? { get set }
    var detailVCBuilder: DetailVCBuilder? { get set }
    var rootController: UINavigationController? { get set }
}

protocol RouterFavorites {
    var favoritesVCBuilder: MainVCBuilder? { get set }
    var detailVCBuilder: DetailVCBuilder? { get set }
    var rootController: UINavigationController? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialMainViewController()
    func popToRoot()
}

final class Router: RouterProtocol {
    var mainVCBuilder: MainVCBuilder?
    var favoritesVCBuilder: FavoritesVCBuilder?
    var detailVCBuilder: DetailVCBuilder?
    var rootController: UINavigationController?

    init(mainVCBuilder: MainVCBuilder,
         favoritesVCBuilder: FavoritesVCBuilder,
         detailVCBuilder: DetailVCBuilder,
         rootController: UINavigationController) {
        self.mainVCBuilder = mainVCBuilder
        self.favoritesVCBuilder = favoritesVCBuilder
        self.detailVCBuilder = detailVCBuilder
        self.rootController = rootController
    }
    
    func initialMainViewController() {
        if let rootController = rootController {
            guard let mainVC = mainVCBuilder?.createMainViewModule(router: self) else { return }
            rootController.pushViewController(mainVC, animated: true)
        }
    }
    
    func initialFavoritesViewController() {
        if let rootController = rootController {
            guard let mainVC = favoritesVCBuilder?.createFavoritesViewModule(router: self) else { return }
            rootController.pushViewController(mainVC, animated: true)
        }
    }

    func showDetailViewController() {
        if let rootController = rootController {
            guard let detailVC = detailVCBuilder?.createDetailViewModule(router: self) /*(router: self, film: film)*/ else { return }
            rootController.pushViewController(detailVC, animated: true)
        }
    }

    func popToRoot() {
        if let rootController = rootController {
            rootController.popToRootViewController(animated: true)
        }
    }
}
