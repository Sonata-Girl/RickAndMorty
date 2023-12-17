//
//  MainVCBuilder.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 12.12.2023.
//

import UIKit

protocol MainVCBuilderProtocol {
    func createMainViewModule(router: RouterProtocol) -> MainViewController
}

final class MainVCBuilder: MainVCBuilderProtocol {
    func createMainViewModule(router: RouterProtocol) -> MainViewController {
        let view = MainViewController()
        let networkService = NetworkService.shared
        let presenter = MainViewPresenter(
            view: view,
            networkManager: networkService,
            router: router
        )
        view.presenter = presenter
        return view
    }
    
    func createRootController(view: MainViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: view)
        navigationController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "Episodes"),
            selectedImage: UIImage(named: "EpisodesSelect")
        )
        return navigationController
    }
}
