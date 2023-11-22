import Foundation

struct LoginUseCase: LoginUseCaseProtocol {
    private let repository: DragonBallRepositoryProtocol
    
    init(repository: DragonBallRepositoryProtocol = DragonBallRepository()) {
        self.repository = repository
    }
    
    func execute(
        for user: String,
        with password: String,
        then completion: @escaping (Result<Void, ApiError>) -> Void
    ) {
        repository.login(for: user, with: password) { result in
            switch result {
            case let .success(token):
                self.repository.saveLocalSecure(.token, value: token)
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
