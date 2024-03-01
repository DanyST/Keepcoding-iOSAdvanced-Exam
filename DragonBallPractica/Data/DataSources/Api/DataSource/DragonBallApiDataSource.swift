import Foundation

struct DragonBallApiDataSource {
    private let networkProvider: NetworkProviderProtocol
    private let heroDTOToDomainMapper: HeroDTOToDomainMapperProtocol
    private let heroLocationDTOToDomainMapper: HeroLocationDTOToDomainMapperProtocol
    
    init(
        networkProvider: NetworkProviderProtocol,
        heroDTOToDomainMapper: HeroDTOToDomainMapperProtocol = HeroDTOToDomainMapper(),
        heroLocationDTOToDomainMapper: HeroLocationDTOToDomainMapperProtocol = HeroLocationDTOToDomainMapper()
    ) {
        self.networkProvider = networkProvider
        self.heroDTOToDomainMapper = heroDTOToDomainMapper
        self.heroLocationDTOToDomainMapper = heroLocationDTOToDomainMapper
    }
}

extension DragonBallApiDataSource: DragonBallApiDataSourceProtocol {
    func login(
        for user: String,
        with password: String,
        then completion: @escaping (Result<String, ApiError>) -> Void
    ) {
        guard let loginData = String(format: "%@:%@", user, password)
            .data(using: .utf8)?
            .base64EncodedString()
        else {
            completion(.failure(.parsingHeaders))
            return
        }        
        let authorizationHeader = [NetworkConstants.Header.Key.authorization: "\(NetworkConstants.Header.Value.basic) \(loginData)"]
        
        networkProvider.request(from: .login, additionalHeaders: authorizationHeader) { result in
            switch result {
            case let .success(data):
                guard let token = String(data: data, encoding: .utf8) else {
                    completion(.failure(.decodingData))
                    return
                }
                completion(.success(token))
            case let.failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func getHeroes(withName name: String?, token: String, completion: @escaping (Result<[Hero], ApiError>) -> Void) {
        let authorizationHeader = getAuthorizationHeader(by: token)
        
        networkProvider.request(of: HeroesDTO.self, from: .heroes(name: name), additionalHeaders: authorizationHeader) { result in
            switch result {
            case let .success(heroesDTO):
                let heroes = heroesDTO.compactMap { self.heroDTOToDomainMapper.map($0) }
                completion(.success(heroes))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func getHeroLocations(by hero: Hero, token: String, completion: @escaping (Result<[HeroLocation], ApiError>) -> Void) {
        let authorizationHeader = getAuthorizationHeader(by: token)
        
        networkProvider.request(of: [HeroLocationDTO].self, from: .heroLocations(heroId: hero.id), additionalHeaders: authorizationHeader) { result in
            switch result {
            case let .success(heroLocationsDTO):
                let heroLocations = heroLocationsDTO.compactMap { self.heroLocationDTOToDomainMapper.map($0, with: hero) }
                completion(.success(heroLocations))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

private extension DragonBallApiDataSource {
    func getAuthorizationHeader(by token: String) -> [String: String] {
        [NetworkConstants.Header.Key.authorization: "\(NetworkConstants.Header.Value.bearer) \(token)"]
    }
}
