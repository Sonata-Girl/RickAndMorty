//
//  TabBarController.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 13.12.2023.
//
import UIKit

final class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBarAppearance()
    }
    
    // MARK: Setup tabBar design
    
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
    
    // MARK: Setup tabBar viewControllers
    
    func configureTabBar(
        mainVC: UINavigationController,
        favoritesVC: UINavigationController
    ) {
        viewControllers = [mainVC, favoritesVC]
    }
}
