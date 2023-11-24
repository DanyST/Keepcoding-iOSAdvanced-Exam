import Foundation

struct GetHeroesUseCase: GetHeroesUseCaseProtocol {
    private let repository: DragonBallRepositoryProtocol
    
    init(repository: DragonBallRepositoryProtocol = DragonBallRepository()) {
        self.repository = repository
    }
    
    func execute(name: String?, completion: @escaping (Result<Heroes, ApiError>) -> Void) {
        repository.getHeroes(withName: name, completion: completion)
    }
}
