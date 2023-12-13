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
        view.backgroundColor = .systemGray5
//        tabBar.tintColor = .systemOrange
//        tabBar.isTranslucent = false
//        tabBar.tintColor = .black // выделенный элемент
//        tabBar.unselectedItemTintColor = .black
       
        let shadowLayer = CALayer()
        shadowLayer.frame = CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 0.5)
        shadowLayer.backgroundColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0, height: -1)
        shadowLayer.shadowOpacity = 1
        shadowLayer.shadowRadius = 1

        // Добавление слоя на tabBar
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
                image: UIImage(named: "episodes"),
                selectedImage: UIImage(named: "episodesSelect")
            ),
            generateVC(
                viewController: favoritesVC,
                title: "",
                image: UIImage(named: "favorites"),
                selectedImage: UIImage(named: "favoritesSelect")
            ),
       ]
    }
}
