//
//  AppBuilder.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 17.12.2023.
//

import UIKit

final class AppBuilder {
    static let shared = AppBuilder()
    private let tabBarController = CustomTabBarController()
    
    private init() {}
    
    func setupTabBar() -> UITabBarController {
        let mainVCBuilder = MainVCBuilder()
        let favoritesVCBuilder = FavoritesVCBuilder()
        let detailVCBuilder = DetailVCBuilder()
        let routerMainVC = RouterMainVC(
            mainVCBuilder: mainVCBuilder,
            detailVCBuilder: detailVCBuilder
        )
        
        let routerFavoriteVC = RouterFavoritesVC(
            favoritesVCBuilder: favoritesVCBuilder,
            detailVCBuilder: detailVCBuilder
        )
        
        routerMainVC.initialMainViewController()
        routerFavoriteVC.initialFavoritesViewController()
        
        guard let mainRootController = routerMainVC.rootController,
              let favoritesRootController = routerFavoriteVC.rootController else { return tabBarController }
        tabBarController.configureTabBar(
            mainVC: mainRootController,
            favoritesVC: favoritesRootController
        )
        
        return tabBarController
    }
}
