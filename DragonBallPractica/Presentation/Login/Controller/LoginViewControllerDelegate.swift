import Foundation

protocol LoginViewControllerDelegate {
    var viewState: ((LoginViewState) -> Void)? { get set }
    func onLoginPressed(with email: String?, and password: String?)
}
