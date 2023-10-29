//
//  SplashViewModel.swift
//  DragonBallPractica
//
//  Created by Luis Eduardo Herrera Lillo on 29-10-23.
//

import Foundation

final class SplashViewModel {
    private var _viewState: ((SplashViewState) -> Void)?
}

extension SplashViewModel: SplashViewControllerDelegate {
    var viewState: ((SplashViewState) -> Void)? {
        get {
            _viewState
        }
        set {
            _viewState = newValue
        }
    }
    
    func onViewsLoaded() {
        viewState?(.loading(true))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
            self?.viewState?(.loading(false))
            self?.viewState?(.navigateToLogin)
        }
    }
}
