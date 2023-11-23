//
//  LoginViewController.swift
//  DragonBallPractica
//
//  Created by Luis Eduardo Herrera Lillo on 29-10-23.
//

import UIKit

// MARK: - Protocol
protocol LoginViewControllerDelegate {
    var viewState: ((LoginViewState) -> Void)? { get set }
    func onLoginPressed(with email: String?, and password: String?)
}

final class LoginViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var centerYFieldsStackViewConstraint: NSLayoutConstraint!
    
    // MARK: - ViewModel
    var viewModel: LoginViewControllerDelegate?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // MARK: - Add Keyboard Observers
        addKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // MARK: - remove Keyboard Observers
        removeKeyboardObservers()
    }
}

// MARK: - Actions
extension LoginViewController {
    @IBAction private func didTapLoginButton() {
        dismissKeyboard()
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
        
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        view.addGestureRecognizer(tapGestureRecognizer)
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
                    self.navigateToNext()
                }
            }
        }
    }
    
    private func updateLoadingView(_ isLoading: Bool) {
        loadingView.isHidden = !isLoading
    }
    
    private func updateLabelError(label: UILabel, error: String?) {
        label.text = error
        label.isHidden = error?.isEmpty == true
    }
    
    private func navigateToNext() {
        let storyboard = UIStoryboard.storyboard(.heroes)
        let viewController: HeroesViewController = storyboard.instantiateViewController()
        let viewModel = HeroesViewModel()
        viewController.viewModel = viewModel
        navigationController?.setViewControllers([viewController], animated: true)
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
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

extension LoginViewController {
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            UIView.animate(withDuration: 0.25) { [weak self] in
                self?.centerYFieldsStackViewConstraint.constant = -keyboardHeight / 6
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    @objc
    private func keyboardWillHide() {
        centerYFieldsStackViewConstraint.constant = 0.0
        view.layoutIfNeeded()
    }
}
