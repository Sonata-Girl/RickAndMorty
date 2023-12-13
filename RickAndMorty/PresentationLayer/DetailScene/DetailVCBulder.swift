//
//  DetailVCBulder.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 13.12.2023.
//

import UIKit

protocol DetailVCBulderProtocol {
    func createDetailViewModule(router: RouterProtocol) -> UIViewController
}

final class DetailVCBuilder: DetailVCBulderProtocol {
    func createDetailViewModule(router: RouterProtocol) -> UIViewController {
        let view = DetailViewController()
//        let networkService = NetworkService()
//        let presenter = DetailVCPresenter(view: view, networkService: networkService, router: router)
//        view.presenter = presenter

        return view
    }
}
