//
//  MainVCBuilder.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 12.12.2023.
//

import UIKit

protocol MainVCBuilderProtocol {
    func createMainViewModule(router: RouterProtocol) -> UIViewController
}

final class MainVCBuilder: MainVCBuilderProtocol {
    func createMainViewModule(router: RouterProtocol) -> UIViewController {
        let view = MainViewController()
//        let networkService = NetworkService()
//        let presenter = MainTableViewPresenter(view: view, networkService: networkService, router: router)
//        view.presenter = presenter

        return view
    }
}
