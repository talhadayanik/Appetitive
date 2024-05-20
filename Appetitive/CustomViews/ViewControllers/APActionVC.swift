//
//  APActionVC.swift
//  Appetitive
//
//  Created by Talha Dayanık on 26.05.2024.
//

import UIKit

protocol APActionVCDelegate {
    func actionButtonPressed(type: APActionVCType)
}

enum APActionVCType {
    case yemekSil
    case siparisVer
}

class APActionVC: UIViewController {
    
    let containerView   = APAlertContainerView()
    let titleLabel      = APTitleLabel(textAlignment: .center, fontSize: 20)
    let messageLabel    = APBodyLabel(textAlignment: .center, fontSize: 16)
    let actionButton    = APButton(backgroundColor: .systemPink, title: "Ok")
    let cancelButton    = APButton(backgroundColor: .systemMint, title: "Cancel")
    
    var alertTitle: String?
    var message: String?
    var actionButtonTitle: String?
    var cancelButtonTitle: String?
    var type: APActionVCType?
    
    let padding: CGFloat = 20
    
    var delegate: APActionVCDelegate
    
    
    init(title: String, message: String, actionButtonTitle: String, cancelButtonTitle: String, actionVCDelegate: APActionVCDelegate, type: APActionVCType) {
        self.delegate             = actionVCDelegate
        super.init(nibName: nil, bundle: nil)
        self.alertTitle           = title
        self.message              = message
        self.actionButtonTitle    = actionButtonTitle
        self.cancelButtonTitle    = cancelButtonTitle
        self.type                 = type
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        view.addSubviews(containerView, titleLabel, actionButton, messageLabel, cancelButton)
        
        configureContainerView()
        configureTitleLabel()
        configureMessageLabel()
        configureActionButton()
        configureCancelButton()
    }
    
    
    private func configureContainerView() {
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    
    private func configureTitleLabel() {
        titleLabel.text = alertTitle ?? "Something went wrong"
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    
    private func configureMessageLabel() {
        messageLabel.text           = message ?? "Unable to complete request"
        messageLabel.numberOfLines  = 4
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding)
        ])
    }
    
    
    private func configureActionButton() {
        actionButton.setTitle(actionButtonTitle ?? "Ok", for: .normal)
        actionButton.addTarget(self, action: #selector(onActionButtonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: padding),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    
    private func configureCancelButton() {
        cancelButton.setTitle(cancelButtonTitle ?? "Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: padding),
            cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            cancelButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            cancelButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    
    @objc func onActionButtonPressed() {
        delegate.actionButtonPressed(type: self.type!)
    }
    
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}
