import Foundation

struct DeleteSessionTokenUseCase: DeleteSessionTokenUseCaseProtocol {
    private let repository: DragonBallRepositoryProtocol
    
    init(repository: DragonBallRepositoryProtocol = DragonBallRepository()) {
        self.repository = repository
    }
    
    @discardableResult
    func execute() -> Bool {
        repository.deleteLocalSecure(.token)
    }
}
