import Foundation

struct IsLoggedUseCase: IsLoggedUseCaseProtocol {
    private let repository: DragonBallRepositoryProtocol
    
    init(repository: DragonBallRepositoryProtocol = DragonBallRepository()) {
        self.repository = repository
    }
    
    func execute() -> Bool {
        let token = repository.getLocalSecure(.token)
        return token?.isEmpty == false
    }
}
