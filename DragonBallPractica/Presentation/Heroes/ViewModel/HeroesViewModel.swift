import Foundation

final class HeroesViewModel {
    private let getHeroesUseCase: GetHeroesUseCaseProtocol
    private let deleteSessionTokenUseCase: DeleteSessionTokenUseCaseProtocol
    private var _viewState: ((HeroesViewState) -> Void)?
    
    init(
        getHeroesUseCase: GetHeroesUseCaseProtocol,
        deleteSessionTokenUseCase: DeleteSessionTokenUseCaseProtocol
    ) {
        self.getHeroesUseCase = getHeroesUseCase
        self.deleteSessionTokenUseCase = deleteSessionTokenUseCase
    }
    
    private var heroes = [Hero]()
    
    private func loadData() {
        viewState?(.loading(true))
        
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            
            self.getHeroesUseCase.execute(name: nil) { result in
                self.viewState?(.loading(false))
                switch result {
                case let .success(heroes):
                    self.heroes = heroes
                    self.viewState?(.updateData)
                case let .failure(error):
                    self.heroes = []
                    print("Error: \(error)")
                }
            }
        }
    }
}

extension HeroesViewModel: HeroesViewControllerDelegate {
    var viewState: ((HeroesViewState) -> Void)? {
        get {
            _viewState
        }
        set {
            _viewState = newValue
        }
    }
    
    var title: String {
        "Discover Heroes"
    }
    
    var dataCount: Int {
        heroes.count
    }
    
    func onViewsLoaded() {
        loadData()
    }
    
    func heroCellModel(at index: Int) -> HeroCellModel? {
        guard let hero = hero(at: index) else {
            return nil
        }
        let heroCellModel = HeroCellModel(
            photo: hero.photo,
            name: hero.name
        )
        return heroCellModel
    }
    
    func onItemSelected(at index: Int) {
        guard let hero = hero(at: index) else {
            return
        }
        viewState?(.navigateToHeroDetail(hero: hero))
    }
    
    func logoutButtonDidtap() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.deleteSessionTokenUseCase.execute()
            self?.viewState?(.navigateToLogin)
        }
    }
    
    func mapButtonDidTap() {
        viewState?(.navigateToHeroesMap)
    }
}

private extension HeroesViewModel {
    func hero(at index: Int) -> Hero? {
        guard heroes.indices.contains(index) else {
            return nil
        }
        return heroes[index]
    }
}
