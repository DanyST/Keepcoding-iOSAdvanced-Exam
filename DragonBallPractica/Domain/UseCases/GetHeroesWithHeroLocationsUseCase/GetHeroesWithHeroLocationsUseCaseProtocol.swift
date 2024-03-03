import Foundation

protocol GetHeroesWithHeroLocationsUseCaseProtocol {
    func execute(heroName: String?, completion: @escaping (Result<[HeroLocation], ApiError>) -> Void)
}
