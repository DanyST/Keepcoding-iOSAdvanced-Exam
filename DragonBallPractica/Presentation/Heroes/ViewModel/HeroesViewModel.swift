import Foundation

final class HeroesViewModel {
    private let getHeroesUseCase: GetHeroesUseCaseProtocol
    private var _viewState: ((HeroesViewState) -> Void)?
    
    init(getHeroesUseCase: GetHeroesUseCaseProtocol) {
        self.getHeroesUseCase = getHeroesUseCase
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
        guard heroes.indices.contains(index) else {
            return nil
        }
        let hero = heroes[index]
        let heroCellModel = HeroCellModel(
            photo: hero.photo,
            name: hero.name
        )
        return heroCellModel
    }
    
    func onItemSelected(at index: Int) {
        viewState?(.navigateToHeroDetail)
    }
}
