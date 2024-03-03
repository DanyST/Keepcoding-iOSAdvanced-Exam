import Foundation

struct GetHeroLocationsUseCase: GetHeroLocationsUseCaseProtocol {
    private let repository: DragonBallRepositoryProtocol
    
    init(repository: DragonBallRepositoryProtocol = DragonBallRepository()) {
        self.repository = repository
    }
    
    func execute(with hero: Hero, completion: @escaping (Result<[HeroLocation], ApiError>) -> Void) {
        let localHeroLocations = repository.getHeroLocationsFromDataBase(by: hero)
        
        if localHeroLocations.isEmpty {
            fetchAndHandleRemoteHeroLocations(by: hero, completion: completion)
        } else {
            completion(.success(localHeroLocations))
        }
    }
}

private extension GetHeroLocationsUseCase {
    func fetchAndHandleRemoteHeroLocations(by hero: Hero, completion: @escaping (Result<[HeroLocation], ApiError>) -> Void) {
                
        repository.getHeroLocations(by: hero) { result in
            switch result {
            case let .success(remoteHeroLocations):
                repository.saveHeroLocationsInLocalDatabase(remoteHeroLocations, to: hero)
                completion(.success(remoteHeroLocations))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

