import Foundation

final class DragonBallApiDataSource {
    private let networkProvider: NetworkProviderProtocol
    
    init(networkProvider: NetworkProviderProtocol) {
        self.networkProvider = networkProvider
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
        let authorizationHeader = [ApiConstants.Header.Key.authorization: "\(ApiConstants.Header.Value.basic) \(loginData)"]
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
    
    func getHeroes(withName name: String?, token: String, completion: @escaping (Result<[HeroDTO], ApiError>) -> Void) {
        let authorizationHeader = [ApiConstants.Header.Key.authorization: "\(ApiConstants.Header.Value.bearer) \(token)"]
        networkProvider.request(of: HeroesDTO.self, from: .heroes(name: name), additionalHeaders: authorizationHeader, then: completion)
    }
}
