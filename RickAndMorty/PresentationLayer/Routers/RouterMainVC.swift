//
//  RouterMain.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 16.12.2023.
//

import UIKit

final class RouterMainVC: RouterMainVCProtocol {
    var mainVCBuilder: MainVCBuilder?
    var detailVCBuilder: DetailVCBuilder?
    var rootController: UINavigationController?

    init(mainVCBuilder: MainVCBuilder,
         detailVCBuilder: DetailVCBuilder) {
        self.mainVCBuilder = mainVCBuilder
        self.detailVCBuilder = detailVCBuilder
    }
    
    func initialMainViewController() {
        guard let builder = mainVCBuilder else { return }
        let mainVC = builder.createMainViewModule(router: self)
        rootController = builder.createRootController(view: mainVC)
    }

    func showDetailViewController(characterModel: CharacterModel) {
        if let rootController = rootController {
            guard let detailVC = detailVCBuilder?.createDetailViewModule(
                router: self,
                characterModel: characterModel
            ) else { return }
            rootController.pushViewController(detailVC, animated: true)
        }
    }

    func popToRoot() {
        if let rootController = rootController {
            rootController.popToRootViewController(animated: true)
        }
    }
}
