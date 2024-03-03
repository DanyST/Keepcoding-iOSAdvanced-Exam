import Foundation
import KeychainSwift

final class SecureLocalDataSource {
    private let keychain = KeychainSwift()
}

extension SecureLocalDataSource: SecureLocalDataSourceProtocol {
    func save(_ keyType: SecureLocalType, value: String) -> Bool {
        keychain.set(value, forKey: keyType.rawValue)
    }
    
    func get(_ keyType: SecureLocalType) -> String? {
        keychain.get(keyType.rawValue)
    }
    
    func delete(_ keyType: SecureLocalType) -> Bool {
        keychain.delete(keyType.rawValue)
    }
}
