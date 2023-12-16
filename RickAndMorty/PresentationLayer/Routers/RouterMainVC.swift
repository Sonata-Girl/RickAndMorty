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
         detailVCBuilder: DetailVCBuilder,
         rootController: UINavigationController) {
        self.mainVCBuilder = mainVCBuilder
        self.detailVCBuilder = detailVCBuilder
        self.rootController = rootController
    }
    
    func initialMainViewController() {
        if let rootController = rootController {
            guard let mainVC = mainVCBuilder?.createMainViewModule(router: self) else { return }
            rootController.pushViewController(mainVC, animated: true)
        }
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
