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

        launchScreenPresenter?.present()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
            guard let self else { return }
            self.launchScreenPresenter?.dismiss(completion: {
                self.launchScreenPresenter = nil
            })
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let mainVCBuilder = MainVCBuilder()
//        let detailModuleBuilder = DetailModuleBuilder()
        let navigationController = UINavigationController()
        let router = Router(mainVCBuilder: mainVCBuilder, rootController: navigationController)
        router.initialViewController()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
         
        return true
    }
}
