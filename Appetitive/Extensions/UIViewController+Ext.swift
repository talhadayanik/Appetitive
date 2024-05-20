//
//  UIViewController+Ext.swift
//  Appetitive
//
//  Created by Talha Dayanık on 21.05.2024.
//

import UIKit

extension UIViewController {
    
    func presentAPAlertOnMainThread(title: String, message: String, buttonTitle: String, alertVCDelegate: APAlertVCDelegate?) {
        DispatchQueue.main.async {
            let alertVC = APAlertVC(title: title, message: message, buttonTitle: buttonTitle, alertVCDelegate: alertVCDelegate)
            alertVC.modalPresentationStyle  = .overFullScreen
            alertVC.modalTransitionStyle    = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    
    func presentAPActionOnMainThread(title: String, message: String, actionButtonTitle: String, cancelButtonTitle: String, actionVCDelegate: APActionVCDelegate, type: APActionVCType) {
        DispatchQueue.main.async {
            let actionVC = APActionVC(title: title, message: message, actionButtonTitle: actionButtonTitle, cancelButtonTitle: cancelButtonTitle, actionVCDelegate: actionVCDelegate, type: type)
            actionVC.modalPresentationStyle  = .overFullScreen
            actionVC.modalTransitionStyle    = .crossDissolve
            self.present(actionVC, animated: true)
        }
    }
    
    
    func showToast(message : String, font: UIFont) {

        let toastLabel              = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: 110, width: 150, height: 35))
        toastLabel.backgroundColor      = UIColor.systemPink.withAlphaComponent(0.6)
        toastLabel.textColor            = UIColor.white
        toastLabel.font                 = font
        toastLabel.textAlignment        = .center;
        toastLabel.text                 = message
        toastLabel.alpha                = 1.0
        toastLabel.layer.cornerRadius   = 10;
        toastLabel.clipsToBounds        =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 1.5, delay: 0.5, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
