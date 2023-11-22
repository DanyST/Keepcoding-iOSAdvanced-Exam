import Foundation

final class LoginViewModel {
    // MARK: - Properties
    private var _viewState: ((LoginViewState) -> Void)?
    private let loginValidatorUseCase: LoginValidatorUseCaseProtocol
    private let loginUseCase: LoginUseCaseProtocol
    
    // MARK: - Initialization
    init(
        loginUseCase: LoginUseCaseProtocol,
        loginValidatorUseCase: LoginValidatorUseCaseProtocol
    ) {
        self.loginValidatorUseCase = loginValidatorUseCase
        self.loginUseCase = loginUseCase
    }
}

// MARK: - Private Methods
extension LoginViewModel {
    private func doLoginWith(email: String, password: String) {
        loginUseCase.execute(for: email, with: password) { [weak self] result in
            defer {
                self?.viewState?(.loading(false))
            }
            switch result {
            case .success:
                self?.viewState?(.navigateToNext)
            case let .failure(error):
                print("Error: ", error)
                self?.viewState?(.showErrorPassword("Invalid username and/or password. Please check your credentials and try again"))
            }
        }
    }
}

// MARK: - LoginViewControllerDelegate
extension LoginViewModel: LoginViewControllerDelegate {
    var viewState: ((LoginViewState) -> Void)? {
        get {
            _viewState
        }
        set {
            _viewState = newValue
        }
    }
    
    func onLoginPressed(with email: String?, and password: String?) {
        viewState?(.loading(true))
        
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            guard self.loginValidatorUseCase.isValid(email: email) else {
                self.viewState?(.loading(false))
                self.viewState?(.showErrorEmail("Please enter a valid email"))
                return
            }
            
            guard self.loginValidatorUseCase.isValid(password: password) else {
                self.viewState?(.loading(false))
                self.viewState?(.showErrorPassword("Please enter a valid password"))
                return
            }
            
            self.doLoginWith(
                email: email ?? "",
                password: password ?? ""
            )
        }
    }
}
