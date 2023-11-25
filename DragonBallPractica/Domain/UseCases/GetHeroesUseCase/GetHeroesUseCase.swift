import Foundation

struct GetHeroesUseCase: GetHeroesUseCaseProtocol {
    private let repository: DragonBallRepositoryProtocol
    
    init(repository: DragonBallRepositoryProtocol = DragonBallRepository()) {
        self.repository = repository
    }
    
    func execute(name: String?, completion: @escaping (Result<Heroes, ApiError>) -> Void) {
        let localHeroes = repository.getHeroesFromDatabase()
        
        if localHeroes.isEmpty {
            fetchAndHandleRemoteHeroes(withName: name, completion: completion)
        } else {
            completion(.success(localHeroes))
        }
    }
}

private extension GetHeroesUseCase {
    func fetchAndHandleRemoteHeroes(withName name: String?, completion: @escaping (Result<Heroes, ApiError>) -> Void) {
        repository.getHeroes(withName: name) { result in
            switch result {
            case let .success(remoteHeroes):
                repository.saveHeroesInLocalDatabase(remoteHeroes)
                completion(.success(remoteHeroes))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
