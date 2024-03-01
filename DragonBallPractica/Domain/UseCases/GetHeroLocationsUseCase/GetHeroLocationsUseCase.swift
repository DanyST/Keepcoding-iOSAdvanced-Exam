import Foundation

struct GetHeroLocationsUseCase: GetHeroLocationsUseCaseProtocol {
    private let repository: DragonBallRepositoryProtocol
    
    init(repository: DragonBallRepositoryProtocol = DragonBallRepository()) {
        self.repository = repository
    }
    
    func execute(with hero: Hero, completion: @escaping (Result<[HeroLocation], ApiError>) -> Void) {
        repository.getHeroLocations(by: hero, completion: completion)
    }
}
