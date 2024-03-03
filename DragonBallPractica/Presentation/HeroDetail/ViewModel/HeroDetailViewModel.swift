import Foundation

final class HeroDetailViewModel {
    private var _viewState: ((HeroDetailViewState) -> Void)?
    private let hero: Hero
    private let getHeroLocationsUseCase: GetHeroLocationsUseCaseProtocol
    private let heroLocationsToHeroAnnotationsMapper: HeroLocationsToHeroAnnotationsMapperProtocol
    
    init(
        hero: Hero,
        getHeroLocationsUseCase: GetHeroLocationsUseCaseProtocol,
        heroLocationsToHeroAnnotationsMapper: HeroLocationsToHeroAnnotationsMapperProtocol
    ) {
        self.hero = hero
        self.getHeroLocationsUseCase = getHeroLocationsUseCase
        self.heroLocationsToHeroAnnotationsMapper = heroLocationsToHeroAnnotationsMapper
    }
    
    private func loadData() {
        viewState?(.loading(true))
        viewState?(.updateHero(hero: hero))
        
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            self.getHeroLocationsUseCase.execute(with: self.hero) { result in
                self.viewState?(.loading(false))
                switch result {                
                case let .success(heroLocations):
                    let heroAnnotations = self.heroLocationsToHeroAnnotationsMapper.map(
                        heroLocations,
                        with: self.hero
                    )
                    self.viewState?(.updateMap(heroAnnotations: heroAnnotations))
                case let.failure(error):
                    print("Error: \(error)")
                }
            }
        }
    }
}

extension HeroDetailViewModel: HeroDetailViewControllerDelegate {
    var viewState: ((HeroDetailViewState) -> Void)? {
        get {
            _viewState
        }
        set {
            _viewState = newValue
        }
    }
    
    func onViewsLoaded() {
        loadData()
    }
}
