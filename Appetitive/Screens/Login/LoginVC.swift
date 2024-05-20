//
//  LoginVC.swift
//  Appetitive
//
//  Created by Talha Dayanık on 21.05.2024.
//

import UIKit

class LoginVC: UIViewController {
    
    let logoLabel                    = UILabel(frame: .zero)
    let emailTextField               = APTextField(placeholder: "Email", isSecure: false)
    let passwordTextField            = APTextField(placeholder: "Password", isSecure: true)
    let firstButtonLabel             = APTitleLabel(textAlignment: .center, fontSize: 32, color: .systemPink, clickable: true)
    let secondButtonLabel            = APBodyLabel(textAlignment: .center, fontSize: 16, color: .systemPink, clickable: true)
    
    var isActionButtonLogin: Bool = true
    
    var viewModel = LoginViewModel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubviews(logoLabel, emailTextField, passwordTextField, firstButtonLabel, secondButtonLabel)
        configureLogoLabel()
        configureEmailTextField()
        configurePasswordTextField()
        configureFirstButtonLabel()
        configureSecondButtonLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        emailTextField.text     = ""
        passwordTextField.text  = ""
    }
    
    
    private func configureLogoLabel() {
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        logoLabel.font          = UIFont(name: "Pacifico-Regular", size: 45)
        logoLabel.textColor     = .systemPink
        logoLabel.text          = "Appetitive"
        logoLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            logoLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 256),
            logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
    }
    
    
    private func configureEmailTextField() {
        
        emailTextField.autocapitalizationType = .none
        emailTextField.layer.borderColor      = UIColor.systemPink.cgColor
        emailTextField.textColor              = .systemPink
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: 32),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            emailTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    private func configurePasswordTextField() {
        
        passwordTextField.autocapitalizationType = .none
        passwordTextField.layer.borderColor      = UIColor.systemPink.cgColor
        passwordTextField.textColor              = .systemPink
        
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 26),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    private func configureFirstButtonLabel() {
        firstButtonLabel.text    = "Login"
        firstButtonLabel.onClick = { [weak self] in
            guard let self = self else { return }
            
            if let email = self.emailTextField.text, !email.isEmpty, let password = self.passwordTextField.text, !password.isEmpty {
                
                if self.isActionButtonLogin {
                    self.viewModel.signIn(email: email, password: password) { [weak self] result, error in
                        guard let self = self else { return }
                        
                        if let error = error {
                            self.presentAPAlertOnMainThread(title: "Hata", message: error.localizedDescription, buttonTitle: "Tamam", alertVCDelegate: nil)
                            print(error)
                            return
                        }
                        
                        let tabBarController = APTabBarController()
                        AuthManager.shared.currentUser = viewModel.getCurrentUser()
                        self.present(tabBarController, animated: true)
                    }
                } else {
                    self.viewModel.signUp(email: email, password: password) { [weak self] result, error in
                        guard let self = self else { return }
                        
                        if let error = error {
                            self.presentAPAlertOnMainThread(title: "Hata", message: error.localizedDescription, buttonTitle: "Tamam", alertVCDelegate: nil)
                            print(error)
                            return
                        }
                        
                        let tabBarController = APTabBarController()
                        AuthManager.shared.currentUser = viewModel.getCurrentUser()
                        self.present(tabBarController, animated: true)
                    }
                }
                
            } else {
                self.presentAPAlertOnMainThread(title: "Hata", message: "Alanlar boş bırakılamaz.", buttonTitle: "Tamam", alertVCDelegate: nil)
            }
        }
        
        NSLayoutConstraint.activate([
            firstButtonLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstButtonLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 32),
            firstButtonLabel.widthAnchor.constraint(equalToConstant: 160),
            firstButtonLabel.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    
    private func configureSecondButtonLabel() {
        secondButtonLabel.text = "Register"
        secondButtonLabel.onClick = {
            self.firstButtonLabel.fadeTransition(0.2)
            self.secondButtonLabel.fadeTransition(0.2)
            if self.isActionButtonLogin {
                self.firstButtonLabel.text  = "Register"
                self.secondButtonLabel.text = "Login"
                self.isActionButtonLogin    = false
                self.passwordTextField.text = ""
            } else {
                self.firstButtonLabel.text  = "Login"
                self.secondButtonLabel.text = "Register"
                self.isActionButtonLogin    = true
                self.passwordTextField.text = ""
            }
        }
        
        NSLayoutConstraint.activate([
            secondButtonLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondButtonLabel.topAnchor.constraint(equalTo: firstButtonLabel.bottomAnchor, constant: 16),
            secondButtonLabel.widthAnchor.constraint(equalToConstant: 160),
            secondButtonLabel.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
}
