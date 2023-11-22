import Foundation

protocol ApiDataSourceProtocol {
    func login(
        for user: String,
        with password: String,
        then completion: @escaping (Result<String, ApiError>) -> Void
    )
}
