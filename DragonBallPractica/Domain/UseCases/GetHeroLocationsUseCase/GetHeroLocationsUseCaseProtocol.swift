import Foundation

protocol GetHeroLocationsUseCaseProtocol {
    func execute(with hero: Hero, completion: @escaping (Result<[HeroLocation], ApiError>) -> Void)
}
