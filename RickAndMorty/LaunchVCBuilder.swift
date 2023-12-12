//
//  LaunchVCBuilder.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 12.12.2023.
//

import UIKit

protocol LaunchVCBuilderProtocol {
    func createLaunchViewModule(router: RouterProtocol) -> UIViewController
}

class LaunchVCBuilder: LaunchVCBuilderProtocol {
    func createLaunchViewModule(router: RouterProtocol) -> UIViewController {
           let view = LaunchViewController()
   //        let networkManager = NetworkService()
           let presenter = LaunchScreenPresenter(
            view: view,
            router: router
           )
           view.presenter = presenter
           return view
       }

}
