//
//  LoginViewController.swift
//  DragonBallPractica
//
//  Created by Luis Eduardo Herrera Lillo on 29-10-23.
//

import UIKit

protocol LoginViewControllerDelegate {
    var viewState: ((LoginViewState) -> Void)? { get set }
    func onViewsLoaded()
    func onLoginPressed(with email: String?, and password: String?)
}

final class LoginViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    // MARK: - ViewModel
    var viewModel: LoginViewControllerDelegate?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setObservers()
        viewModel?.onViewsLoaded()
    }
}

// MARK: - Actions
extension LoginViewController {
    @IBAction private func didTapLoginButton() {
        viewModel?.onLoginPressed(
            with: emailTextField.text,
            and: passwordTextField.text
        )
    }
}

extension LoginViewController {
    private func initViews() {
        emailTextField.becomeFirstResponder()
        emailTextField.delegate = self
        emailTextField.tag = FieldType.email.rawValue
        passwordTextField.delegate = self
        passwordTextField.tag = FieldType.password.rawValue
        
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
    }
    
    private func setObservers() {
        viewModel?.viewState = { [weak self] state in
            guard let self else { return }
            DispatchQueue.main.async {
                switch state {
                case let .loading(isLoading):
                    self.updateLoadingView(isLoading)
                    
                case let .showErrorEmail(errorString):
                    self.updateLabelError(label: self.emailErrorLabel, error: errorString)
                    
                case let .showErrorPassword(errorString):
                    self.updateLabelError(label: self.passwordErrorLabel, error: errorString)
                case .navigateToNext:
                    break
                }
            }
        }
    }
    
    private func updateLoadingView(_ isLoading: Bool) {
        loadingView.isHidden = !isLoading
    }
    
    private func updateLabelError(label: UILabel, error: String) {
        label.text = error
        label.isHidden = error.isEmpty
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch FieldType(rawValue: textField.tag)  {
        case .email:
            emailErrorLabel.isHidden = true
        case .password:
            passwordErrorLabel.isHidden = true
        default: break
        }
    }
}

extension LoginViewController {
    private enum FieldType: Int {
        case email = 0
        case password
    }
}
