import Foundation

final class HeroesMapViewModel {
    private var _viewState: ((HeroesMapViewState) -> Void)?
    private var heroLocations = HeroLocations()
    private let getHeroesWithHeroLocationsUseCase: GetHeroesWithHeroLocationsUseCaseProtocol
    private let heroLocationsToHeroAnnotationsMapper: HeroLocationsToHeroAnnotationsMapperProtocol
    
    init(
        getHeroesWithHeroLocationsUseCase: GetHeroesWithHeroLocationsUseCaseProtocol,
        heroLocationsToHeroAnnotationsMapper: HeroLocationsToHeroAnnotationsMapperProtocol
    ) {
        self.getHeroesWithHeroLocationsUseCase = getHeroesWithHeroLocationsUseCase
        self.heroLocationsToHeroAnnotationsMapper = heroLocationsToHeroAnnotationsMapper
    }
    
    private func loadData() {
        viewState?(.loading(true))
        
        getHeroesWithHeroLocationsUseCase.execute(heroName: nil) { [weak self] result in
            guard let self else { return }
            viewState?(.loading(false))
            
            switch result {
            case let .success(heroLocations):
                self.heroLocations = heroLocations
                let heroAnnotations = heroLocationsToHeroAnnotationsMapper.map(heroLocations)
                self.viewState?(.updateMap(heroAnnotations: heroAnnotations))
            case let .failure(error):
                print(error)
            }
        }
    }
}

extension HeroesMapViewModel: HeroesMapViewControllerDelegate {
    var title: String {
        "Discover Heroes Map"
    }
    
    var viewState: ((HeroesMapViewState) -> Void)? {
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
    
    func didSelect(heroAnnotation: HeroAnnotation) {
        guard let hero = hero(by: heroAnnotation.info ?? "") else { return }
        viewState?(.navigateToHeroDetail(hero: hero))
    }
}

private extension HeroesMapViewModel {
    func hero(by heroId: String) -> Hero? {
        guard let heroLocation = heroLocations.first(where: { $0.hero.id == heroId })
        else {
            return nil
        }
        return heroLocation.hero
    }
}
