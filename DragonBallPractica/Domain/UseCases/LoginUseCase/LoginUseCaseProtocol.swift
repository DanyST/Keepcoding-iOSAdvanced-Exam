import Foundation

protocol LoginUseCaseProtocol {
    func execute(
        for user: String,
        with password: String,
        then completion: @escaping (Result<Void, ApiError>) -> Void
    )
}
