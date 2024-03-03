import UIKit
import Kingfisher

final class HeroesViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    
    // MARK: - Properties
    var viewModel: HeroesViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel?.title
        initViews()
        setObservers()
        viewModel?.onViewsLoaded()
    }
}

private extension HeroesViewController {
    enum Constants {
        static let heightRow: CGFloat = 300.0
    }
}

// MARK: - Configure View
private extension HeroesViewController {
    func initViews() {
        setupNavigationBar()
        setupTableView()
    }
    
    func setupNavigationBar() {
        let logoutButton = UIBarButtonItem(
            title: "Log Out",
            primaryAction: UIAction(handler: { [weak self] _ in
                self?.viewModel?.logoutButtonDidtap()
            })
        )
        
        let mapButton = UIBarButtonItem(
            image: UIImage(systemName: "map"),
            primaryAction: UIAction(handler: { [weak self] _ in
                self?.viewModel?.mapButtonDidTap()
            })
        )
        
        navigationItem.leftBarButtonItem = logoutButton
        navigationItem.rightBarButtonItem = mapButton
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        let heroCellNib = UINib(nibName: "\(HeroCell.self)", bundle: nil)
        tableView.register(heroCellNib, forCellReuseIdentifier: HeroCell.reuseIdentifier)
    }
    
    func setObservers() {
        viewModel?.viewState = { [weak self] state in
            guard let self else { return }
            DispatchQueue.main.async {
                switch state {
                case let .loading(isLoading):
                    self.loadingView.isHidden = !isLoading
                case .updateData:
                    self.tableView.reloadData()
                case let .navigateToHeroDetail(hero):
                    self.navigateToHeroDetail(hero: hero)
                case .navigateToLogin:
                    self.navigateToLogin()
                case .navigateToHeroesMap:
                    self.navigateToHeroesMap()
                }
            }
        }
    }
}

private extension HeroesViewController {
    func navigateToHeroDetail(hero: Hero) {
        let storyboard = UIStoryboard.storyboard(.heroDetail)
        let viewController: HeroDetailViewController = storyboard.instantiateViewController()
        let getHeroLocationsUseCase = GetHeroLocationsUseCase()
        let heroLocationsToHeroAnnotationsMapper = HeroLocationsToHeroAnnotationsMapper()
        let viewModel = HeroDetailViewModel(
            hero: hero,
            getHeroLocationsUseCase: getHeroLocationsUseCase,
            heroLocationsToHeroAnnotationsMapper: heroLocationsToHeroAnnotationsMapper
        )
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func navigateToLogin() {
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
    
    func navigateToHeroesMap() {
        let storyboard = UIStoryboard.storyboard(.heroesMap)
        let viewController: HeroesMapViewController = storyboard.instantiateViewController()
        
        let getHeroesWithHeroLocationsUseCase = GetHeroesWithHeroLocationsUseCase(
            getHeroesUseCase: GetHeroesUseCase(),
            getHeroLocationsUseCase: GetHeroLocationsUseCase()
        )
        let heroLocationsToHeroAnnotationsMapper = HeroLocationsToHeroAnnotationsMapper()
        let viewModel = HeroesMapViewModel(
            getHeroesWithHeroLocationsUseCase: getHeroesWithHeroLocationsUseCase,
            heroLocationsToHeroAnnotationsMapper: heroLocationsToHeroAnnotationsMapper
        )
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UITableViewDelegate
extension HeroesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.heightRow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel?.onItemSelected(at: indexPath.row)
    }
}

// MARK: - UITableViewDataSource
extension HeroesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.dataCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HeroCell.reuseIdentifier, for: indexPath) as? HeroCell else {
            return UITableViewCell()
        }
        
        if let heroCellModel = viewModel?.heroCellModel(at: indexPath.row) {
            cell.updateViews(model: heroCellModel)
        }
        
        return cell
    }
}
