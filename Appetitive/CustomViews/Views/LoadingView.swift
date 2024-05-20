//
//  LoadingView.swift
//  Culture Canvas
//
//  Created by Talha Dayanık on 17.05.2024.
//

import UIKit

class LoadingView {
    
    static let shared = LoadingView()
    
    var activityIndicator: UIActivityIndicatorView  = UIActivityIndicatorView()
    var blurView: UIVisualEffectView                = UIVisualEffectView()
    
    
    private init() {
        configure()
    }
    
    func configure() {
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.frame                      = UIWindow(frame: UIScreen.main.bounds).frame
        activityIndicator.center            = blurView.center
        activityIndicator.hidesWhenStopped  = true
        activityIndicator.style             = .large
        blurView.contentView.addSubview(activityIndicator)
    }
    
    func startLoading() {
        UIApplication.shared.windows.first?.addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        blurView.removeFromSuperview()
        activityIndicator.stopAnimating()
    }
    
}
