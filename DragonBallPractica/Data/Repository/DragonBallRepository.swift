import Foundation

struct DragonBallRepository: DragonBallRepositoryProtocol {
    private let apiRestDataSource: ApiDataSourceProtocol
    private let secureLocalDataSource: SecureLocalDataSourceProtocol
    private let heroDTOToDomainMapper: HeroDTOToDomainMapperProtocol
    
    init(
        apiRestDataSource: ApiDataSourceProtocol = ApiDataSource(networkProvider: NetworkProvider()),
        secureLocalDataSource: SecureLocalDataSourceProtocol = SecureLocalDataSource(),
        heroDTOToDomainMapper: HeroDTOToDomainMapperProtocol = HeroDTOToDomainMapper()
    ) {
        self.apiRestDataSource = apiRestDataSource
        self.secureLocalDataSource = secureLocalDataSource
        self.heroDTOToDomainMapper = heroDTOToDomainMapper
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
        apiRestDataSource.getHeroes(withName: name, token: token) { result in
            switch result {
            case let .success(heroesDTO):
                let heroes = heroesDTO.compactMap { heroDTOToDomainMapper.map($0) }
                completion(.success(heroes))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    @discardableResult
    func saveLocalSecure(_ keyType: SecureLocalType, value: String) -> Bool {
        secureLocalDataSource.save(keyType, value: value)
    }
    
    func getLocalSecure(_ keyType: SecureLocalType) -> String? {
        secureLocalDataSource.get(keyType)
    }
}
