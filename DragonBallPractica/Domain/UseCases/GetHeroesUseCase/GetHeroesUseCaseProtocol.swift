import Foundation

protocol GetHeroesUseCaseProtocol {
    func execute(name: String?, completion: @escaping (Result<Heroes, ApiError>) -> Void)
}
