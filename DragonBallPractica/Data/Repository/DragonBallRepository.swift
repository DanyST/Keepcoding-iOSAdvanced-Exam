import Foundation

struct DragonBallRepository: DragonBallRepositoryProtocol {
    private let apiRestDataSource: ApiDataSourceProtocol
    private let secureLocalDataSource: SecureLocalDataSourceProtocol
    
    init(
        apiRestDataSource: ApiDataSourceProtocol = ApiDataSource(networkProvider: NetworkProvider()),
        secureLocalDataSource: SecureLocalDataSourceProtocol = SecureLocalDataSource()
    ) {
        self.apiRestDataSource = apiRestDataSource
        self.secureLocalDataSource = secureLocalDataSource
    }
    
    func login(
        for user: String,
        with password: String,
        then completion: @escaping (Result<String, ApiError>) -> Void
    ) {
        apiRestDataSource.login(for: user, with: password, then: completion)
    }
    
    @discardableResult
    func saveLocalSecure(_ keyType: SecureLocalType, value: String) -> Bool {
        secureLocalDataSource.save(keyType, value: value)
    }
    
    func getLocalSecure(_ keyType: SecureLocalType) -> String? {
        secureLocalDataSource.get(keyType)
    }
}
