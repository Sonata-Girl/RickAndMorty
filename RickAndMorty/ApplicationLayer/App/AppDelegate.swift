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
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(loadingDuration) + .seconds(1)) {
            self.launchScreenPresenter?.dismiss(completion: {
                self.launchScreenPresenter = nil
            })
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = AppBuilder.shared.setupTabBar()
        window?.makeKeyAndVisible()
         
        return true
    }
}
