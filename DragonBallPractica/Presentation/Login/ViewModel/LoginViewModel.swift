//
//  LoginViewModel.swift
//  DragonBallPractica
//
//  Created by Luis Eduardo Herrera Lillo on 29-10-23.
//

import Foundation

final class LoginViewModel {
    // MARK: - Properties
    private var _viewState: ((LoginViewState) -> Void)?
}

// MARK: - Private Methods
extension LoginViewModel {
    private func doLoginWith(email: String, password: String) {
        
    }
    
    private func isValid(email: String?) -> Bool {
        guard let email, !email.isEmpty else { return false }
        
        let regExMatchEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicateEmail = NSPredicate(format:"SELF MATCHES %@", regExMatchEmail)
        return predicateEmail.evaluate(with: email)
    }
    
    private func isValid(password: String?) -> Bool {
        guard let password else { return false }
        return !password.isEmpty && password.count >= 4
    }
}

// MARK: - LoginViewControllerDelegate
extension LoginViewModel: LoginViewControllerDelegate {
    var viewState: ((LoginViewState) -> Void)? {
        get {
            _viewState
        }
        set {
            _viewState = newValue
        }
    }
    
    func onLoginPressed(with email: String?, and password: String?) {
        viewState?(.loading(true))
        
        DispatchQueue.global().async {
            guard self.isValid(email: email) else {
                self.viewState?(.loading(false))
                self.viewState?(.showErrorEmail("Please enter a valid email"))
                return
            }
            
            guard self.isValid(password: password) else {
                self.viewState?(.loading(false))
                self.viewState?(.showErrorPassword("Please enter a valid password"))
                return
            }
            
            self.doLoginWith(
                email: email ?? "",
                password: password ?? ""
            )
        }
    }
}
