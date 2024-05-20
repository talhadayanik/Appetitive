//
//  UIView+Ext.swift
//  Appetitive
//
//  Created by Talha Dayanık on 21.05.2024.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        for view in views { addSubview(view) }
    }
    
    
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation               = CATransition()
        animation.timingFunction    = CAMediaTimingFunction(name:
                                                            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type              = CATransitionType.fade
        animation.duration          = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}
