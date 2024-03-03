import Foundation

protocol DeleteSessionTokenUseCaseProtocol {
    @discardableResult
    func execute() -> Bool
}
