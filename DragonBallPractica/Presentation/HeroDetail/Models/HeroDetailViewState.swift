import Foundation

enum HeroDetailViewState {
    case loading(_ isLoading: Bool)
    case updateHero(hero: Hero)
    case updateHeroLocations(hero: Hero, heroLocations: HeroLocations)
}
