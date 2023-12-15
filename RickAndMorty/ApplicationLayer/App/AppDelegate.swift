//
//  AppDelegate.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 12.12.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private var launchScreenPresenter: LaunchScreenPresenterProtocol? = LaunchScreenPresenter()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // MARK: Launching Animation start
        
        let loadingDuration = 3
        launchScreenPresenter?.present(with: loadingDuration)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(loadingDuration) + .seconds(1)) { [weak self] in
            guard let self else { return }
            self.launchScreenPresenter?.dismiss(completion: {
                self.launchScreenPresenter = nil
            })
        }

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = buildingAppScenes()
        window?.makeKeyAndVisible()
         
        return true
    }
}

// - MARK: Build scenes for app

private extension AppDelegate {
     func buildingAppScenes() -> UITabBarController {
        let tabBarController = TabBarController()
    
        let mainVCBuilder = MainVCBuilder()
        let favoritesVCBuilder = FavoritesVCBuilder()
        let detailVCBuilder = DetailVCBuilder()
        let navigationController = UINavigationController()
        let router = Router(
            mainVCBuilder: mainVCBuilder,
            favoritesVCBuilder: favoritesVCBuilder,
            detailVCBuilder: detailVCBuilder,
            rootController: navigationController
        )
        tabBarController.configureTabBar(
            mainVC: mainVCBuilder.createMainViewModule(router: router),
            favoritesVC: favoritesVCBuilder.createFavoritesViewModule(router: router)
        )
        
        return tabBarController
    }
}
