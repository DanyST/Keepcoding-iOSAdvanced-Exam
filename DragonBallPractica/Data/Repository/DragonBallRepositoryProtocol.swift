import Foundation

protocol DragonBallRepositoryProtocol {
    func login(
        for user: String,
        with password: String,
        then completion: @escaping (Result<String, ApiError>) -> Void
    )
    
    @discardableResult
    func saveLocalSecure(_ keyType: SecureLocalType, value: String) -> Bool
    
    func getLocalSecure(_ keyType: SecureLocalType) -> String?
}
