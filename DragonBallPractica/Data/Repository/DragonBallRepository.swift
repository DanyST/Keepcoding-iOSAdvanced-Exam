import Foundation

struct DragonBallRepository: DragonBallRepositoryProtocol {
    private let apiRestDataSource: DragonBallApiDataSourceProtocol
    private let secureLocalDataSource: SecureLocalDataSourceProtocol
    private let localDatabaseDataSource: LocalDatabaseDataSourceProtocol
    
    init(
        apiRestDataSource: DragonBallApiDataSourceProtocol = DragonBallApiDataSource(networkProvider: NetworkProvider()),
        secureLocalDataSource: SecureLocalDataSourceProtocol = SecureLocalDataSource(),
        localDatabaseDataSource: LocalDatabaseDataSourceProtocol = LocalDatabaseDataSource()
    ) {
        self.apiRestDataSource = apiRestDataSource
        self.secureLocalDataSource = secureLocalDataSource
        self.localDatabaseDataSource = localDatabaseDataSource
    }
    
    func login(
        for user: String,
        with password: String,
        then completion: @escaping (Result<String, ApiError>) -> Void
    ) {
        apiRestDataSource.login(for: user, with: password, then: completion)
    }
    
    func getHeroes(withName name: String?, completion: @escaping (Result<Heroes, ApiError>) -> Void) {
        guard let token = getLocalSecure(.token) else {
            completion(.failure(.noToken))
            return
        }
        apiRestDataSource.getHeroes(withName: name, token: token, completion: completion)
    }
    
    func getHeroLocations(by hero: Hero, completion: @escaping (Result<[HeroLocation], ApiError>) -> Void) {
        guard let token = getLocalSecure(.token) else {
            completion(.failure(.noToken))
            return
        }
        apiRestDataSource.getHeroLocations(by: hero, token: token, completion: completion)
    }
    
    func saveHeroesInLocalDatabase(_ heroes: Heroes) {
        localDatabaseDataSource.add(heroes: heroes)
    }
    
    func getHeroesFromDatabase() -> Heroes {
        localDatabaseDataSource.getHeroes()
    }
    
    @discardableResult
    func saveLocalSecure(_ keyType: SecureLocalType, value: String) -> Bool {
        secureLocalDataSource.save(keyType, value: value)
    }
    
    func getLocalSecure(_ keyType: SecureLocalType) -> String? {
        secureLocalDataSource.get(keyType)
    }
}
