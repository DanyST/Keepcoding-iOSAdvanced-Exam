import Foundation

protocol LoginValidatorUseCaseProtocol {
    func isValid(email: String?) -> Bool
    func isValid(password: String?) -> Bool
}
