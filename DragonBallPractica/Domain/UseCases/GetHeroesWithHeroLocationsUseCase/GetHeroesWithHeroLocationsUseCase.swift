import Foundation

struct GetHeroesWithHeroLocationsUseCase: GetHeroesWithHeroLocationsUseCaseProtocol {
    private let getHeroesUseCase: GetHeroesUseCaseProtocol
    private let getHeroLocationsUseCase: GetHeroLocationsUseCaseProtocol
    
    init(
        getHeroesUseCase: GetHeroesUseCaseProtocol,
        getHeroLocationsUseCase: GetHeroLocationsUseCaseProtocol
    ) {
        self.getHeroesUseCase = getHeroesUseCase
        self.getHeroLocationsUseCase = getHeroLocationsUseCase
    }
    
    func execute(heroName: String?, completion: @escaping (Result<HeroLocations, ApiError>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            getHeroesUseCase.execute(name: heroName) { result in
                switch result {
                case let .success(heroes):
                    handleHeroLocations(by: heroes, completion: completion)
                case let.failure(error):
                    DispatchQueue.main.async { completion(.failure(error)) }
                }
            }
        }
    }
}

private extension GetHeroesWithHeroLocationsUseCase {
    func handleHeroLocations(by heroes: Heroes, completion: @escaping (Result<HeroLocations, ApiError>) -> Void) {
        let dispatchGroup = DispatchGroup()
        var heroLocations = HeroLocations()
        var hasError = false
        
        for hero in heroes {
            dispatchGroup.enter()
            
            getHeroLocationsUseCase.execute(with: hero) { result in
                switch result {
                case let .success(heroLocationsResult):
                    heroLocations.append(contentsOf: heroLocationsResult)
                case let .failure(error):
                    if !hasError {
                        hasError = true
                        
                        DispatchQueue.main.async { completion(.failure(error)) }
                        break
                    }
                }
                
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            if !hasError {
                completion(.success(heroLocations))
            }
        }
    }
}
