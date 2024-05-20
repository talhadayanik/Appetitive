//
//  ProfileVC.swift
//  Appetitive
//
//  Created by Talha Dayanık on 22.05.2024.
//

import UIKit
import FirebaseAuth

class ProfileVC: UIViewController {

    let profileImageView = UIImageView(frame: .zero)
    let emailLabel       = APTitleLabel(textAlignment: .center, fontSize: 32, color: .systemPink)
    let settingsButton   = APButton(backgroundColor: .systemPink, title: "Hesap Ayarları")
    let signOutButton    = APButton(backgroundColor: .systemPink, title: "Çıkış Yap")
    
    var viewModel = ProfileViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureProfileImageView()
        configureEmailLabel()
        configureSettingsButton()
        configureSignOutButton()
    }
    
    
    private func configureProfileImageView() {
        view.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.image = SFSymbols.profilePlaceholderImage
        profileImageView.tintColor = .systemPink
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 256),
            profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor)
        ])
    }
    
    
    private func configureEmailLabel() {
        view.addSubview(emailLabel)
        emailLabel.text = AuthManager.shared.currentUser?.email
        
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 32),
            emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    private func configureSettingsButton() {
        view.addSubview(settingsButton)
        
        NSLayoutConstraint.activate([
            settingsButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 32),
            settingsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            settingsButton.heightAnchor.constraint(equalToConstant: 50),
            settingsButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    
    private func configureSignOutButton() {
        view.addSubview(signOutButton)
        
        signOutButton.addTarget(self, action: #selector(signOutButtonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            signOutButton.topAnchor.constraint(equalTo: settingsButton.bottomAnchor, constant: 32),
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signOutButton.heightAnchor.constraint(equalToConstant: 50),
            signOutButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    
    @objc private func signOutButtonPressed() {
        viewModel.signOut { [weak self] success in
            guard let self = self else { return }
            if success {
                dismiss(animated: true)
            } else {
                presentAPAlertOnMainThread(title: "Hata", message: "Çıkış yapılamadı.", buttonTitle: "Tamam", alertVCDelegate: self)
            }
        }
    }
}


extension ProfileVC: APAlertVCDelegate {
    
    func alertActionButtonPressed() {
        return
    }
}
