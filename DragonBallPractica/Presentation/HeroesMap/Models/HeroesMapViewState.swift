import Foundation

enum HeroesMapViewState {
    case loading(_ isLoading: Bool)
    case updateMap(heroAnnotations: [HeroAnnotation])
    case navigateToHeroDetail(hero: Hero)
}
