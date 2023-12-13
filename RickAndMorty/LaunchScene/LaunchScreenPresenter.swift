//
//  LaunchScreenPresenter.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 12.12.2023.
//

import UIKit

protocol LaunchScreenPresenterProtocol {
    func present()
    func dismiss(completion: (() -> Void)?)
}

final class LaunchScreenPresenter: LaunchScreenPresenterProtocol {
    var view: LaunchViewProtocol?
    
    private var foregroundLaunchWindow: UIWindow? = {
        let launchWindow = UIWindow()
        let launchVC = LaunchViewController()
        
        launchWindow.windowLevel = .normal + 1
        launchWindow.rootViewController = launchVC
        
        return launchWindow
    }()
    
    func present() {
        foregroundLaunchWindow?.isHidden = false
        self.view?.startAnimate()
    }
    
    func dismiss(completion: (() -> Void)?) {
        UIView.animate(withDuration: 1) { [weak self] in
            guard let self else { return }
            self.foregroundLaunchWindow?.alpha = 0
            self.foregroundLaunchWindow?.isHidden = true
            self.foregroundLaunchWindow = nil
        } completion: { (_) in
            completion?()
        }
    }
}
