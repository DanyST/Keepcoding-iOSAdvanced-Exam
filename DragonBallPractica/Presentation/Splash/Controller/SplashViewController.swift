import UIKit

// MARK: - Protocol
protocol SplashViewControllerDelegate {
    func onViewsLoaded()
    var viewState: ((SplashViewState) -> Void)? { get set }
}

final class SplashViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - ViewModel
    var viewModel: SplashViewControllerDelegate?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setObservers()
        viewModel?.onViewsLoaded()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        activityIndicator.isHidden = true
    }
}

// MARK: - Private Methods
extension SplashViewController {
    private func setObservers() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case let .loading(isLoading):
                    self?.activityIndicator.isHidden = !isLoading
                case .navigateToLogin:
                    self?.navigateToLogin()
                case .navigateToHome:
                    self?.navigateToHome()
                }
            }
        }
    }
    
    private func navigateToLogin() {
        let storyboard = UIStoryboard.storyboard(.login)
        let viewController: LoginViewController = storyboard.instantiateViewController()
        let loginUseCase = LoginUseCase()
        let loginValidatorUseCase = LoginValidatorUseCase()
        let viewModel = LoginViewModel(
            loginUseCase: loginUseCase,
            loginValidatorUseCase: loginValidatorUseCase
        )
        viewController.viewModel = viewModel
        navigationController?.setViewControllers([viewController], animated: true)
    }
    
    private func navigateToHome() {
        let storyboard = UIStoryboard.storyboard(.heroes)
        let viewController: HeroesViewController = storyboard.instantiateViewController()
        viewController.viewModel = HeroesViewModel(getHeroesUseCase: GetHeroesUseCase())
        navigationController?.setViewControllers([viewController], animated: true)
    }
}
