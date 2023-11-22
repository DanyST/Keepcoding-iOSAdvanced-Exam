import Foundation

final class SplashViewModel {
    // MARK: - Properties
    private var _viewState: ((SplashViewState) -> Void)?
    private let isLoggedUseCase: IsLoggedUseCaseProtocol
    
    // MARK: - Initialization
    init(isLoggedUseCase: IsLoggedUseCaseProtocol) {
        self.isLoggedUseCase = isLoggedUseCase
    }
}

// MARK: - SplashViewControllerDelegate
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
        
        let isLogged = isLoggedUseCase.execute()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
            guard let self else { return }
            self.viewState?(.loading(false))
            
            guard isLogged else {
                self.viewState?(.navigateToLogin)
                return
            }
            self.viewState?(.navigateToHome)
        }
    }
}
