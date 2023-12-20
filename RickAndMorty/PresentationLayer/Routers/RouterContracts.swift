//
//  RouterMContracts.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 12.12.2023.
//

import UIKit

protocol RouterProtocol {
    var detailVCBuilder: DetailVCBuilder? { get set }
    var rootController: UINavigationController? { get set }
    func showDetailViewController(characterModel: CharacterModel)
    func popToRoot()
}

protocol RouterMainVCProtocol: RouterProtocol {
    var mainVCBuilder: MainVCBuilder? { get set }
    func initialMainViewController()
}

protocol RouterFavoriteVCProtocol: RouterProtocol {
    var favoritesVCBuilder: FavoritesVCBuilder? { get set }
    func initialFavoritesViewController()
}
