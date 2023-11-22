import Foundation

struct LoginValidatorUseCase: LoginValidatorUseCaseProtocol {
    func isValid(email: String?) -> Bool {
        guard let email, !email.isEmpty else { return false }
        
        let regExMatchEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicateEmail = NSPredicate(format:"SELF MATCHES %@", regExMatchEmail)
        return predicateEmail.evaluate(with: email)
    }
    
    func isValid(password: String?) -> Bool {
        guard let password else { return false }
        return !password.isEmpty && password.count >= 4
    }
}
