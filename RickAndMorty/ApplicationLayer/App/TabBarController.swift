//
//  TabBarController.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 13.12.2023.
//
import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBarAppearance()
    }
    
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?, selectedImage: UIImage? ) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(
            title: title,
            image: image,
            selectedImage: selectedImage
        )
        return navigationController
    }
    
    private func setTabBarAppearance() {
        view.backgroundColor = .white
       
        let shadowLayer = CALayer()
        shadowLayer.frame = CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1)
        shadowLayer.backgroundColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.gray.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0, height: -2)
        shadowLayer.shadowOpacity = 0.5
        shadowLayer.shadowRadius = 1
        tabBar.layer.addSublayer(shadowLayer)
    }
    
    func configureTabBar(
        mainVC: MainViewController,
        favoritesVC: FavoritesViewController
    ) {
        viewControllers = [
            generateVC(
                viewController: mainVC,
                title: "",
                image: UIImage(named: "Episodes"),
                selectedImage: UIImage(named: "EpisodesSelect")
            ),
            generateVC(
                viewController: favoritesVC,
                title: "",
                image: UIImage(named: "Favorites"),
                selectedImage: UIImage(named: "FavoritesSelect")
            ),
       ]
    }
}
