import Foundation

enum HeroesViewState {
    case loading(_ isLoading: Bool)
    case updateData
    case navigateToHeroDetail(hero: Hero)
    case navigateToLogin
}
