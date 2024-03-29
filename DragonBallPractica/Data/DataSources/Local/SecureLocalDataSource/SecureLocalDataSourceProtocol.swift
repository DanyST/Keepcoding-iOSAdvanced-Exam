import Foundation

protocol SecureLocalDataSourceProtocol {
    func save(_ keyType: SecureLocalType, value: String) -> Bool
    func get(_ keyType: SecureLocalType) -> String?
    func delete(_ keyType: SecureLocalType) -> Bool
}
