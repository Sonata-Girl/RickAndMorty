//
//  DetailViewPresenter.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 16.12.2023.
//

protocol DetailViewProtocol: AnyObject {
    func configureCharacterDetail(characterModel: CharacterModel)
}

protocol DetailViewPresenterProtocol: AnyObject {
    init(view: DetailViewProtocol, 
         networkService: NetworkServiceProtocol,
         router: RouterProtocol,
         characterModel: CharacterModel
    )
    func configureCharacterDetail()
    func backButtonTapped()
}

final class DetailViewPresenter: DetailViewPresenterProtocol {
    weak var view: DetailViewProtocol?
    var router: RouterProtocol?
    let networkService: NetworkServiceProtocol?
    var characterModel: CharacterModel

    required init(
        view: DetailViewProtocol,
        networkService: NetworkServiceProtocol,
        router: RouterProtocol,
        characterModel: CharacterModel
    ){
        self.view = view
        self.router = router
        self.networkService = networkService
        self.characterModel = characterModel
    }

    func configureCharacterDetail() {
        self.view?.configureCharacterDetail(characterModel: characterModel)
    }

    func backButtonTapped() {
        router?.popToRoot()
    }
}
