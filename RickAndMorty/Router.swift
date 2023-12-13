//
//  Router.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 12.12.2023.
//

import UIKit

protocol RouterMain {
    var mainVCBuilder: MainVCBuilder? { get set }
    var rootController: UINavigationController? { get set }
}

protocol RouterProtocol: RouterMain {
    func showLaunchViewController()
    func initialMainViewController()
    func popToRoot()
}

final class Router: RouterProtocol {
    
    var launchVCBuilder: LaunchVCBuilder?
    var mainVCBuilder: MainVCBuilder?
//    var detailModuleBuilder: DetailModuleBuilder?
    var rootController: UINavigationController?

    init(launchVCBuilder: LaunchVCBuilder,
         mainVCBuilder: MainVCBuilder,
//         detailModuleBuilder: DetailModuleBuilder,
         rootController: UINavigationController) {
        self.launchVCBuilder = launchVCBuilder
        self.mainVCBuilder = mainVCBuilder
//        self.detailModuleBuilder = detailModuleBuilder
        self.rootController = rootController
    }

    func showLaunchViewController() {
        if let rootController = rootController {
            guard let launchVC = launchVCBuilder?.createLaunchViewModule(router: self) else { return }
            rootController.pushViewController(launchVC, animated: true)
        }
    }
    
    func initialMainViewController() {
        if let rootController = rootController {
            guard let mainVC = mainVCBuilder?.createMainViewModule(router: self) else { return }
            rootController.pushViewController(mainVC, animated: true)
        }
    }
//
//    func showDetail(film: Film) {
//        if let rootController = rootController {
//            guard let detailTableView = detailModuleBuilder?.createDetailTableViewModule(router: self, film: film) else { return }
//            rootController.pushViewController(detailTableView, animated: true)
//        }
//    }

    func popToRoot() {
        if let rootController = rootController {
            rootController.popToRootViewController(animated: true)
        }
    }
}
