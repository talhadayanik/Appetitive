//
//  APBodyLabel.swift
//  Appetitive
//
//  Created by Talha Dayanık on 21.05.2024.
//

import UIKit

class APBodyLabel: UILabel {
    
    var onClick: () -> Void = {}
    

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat, color: UIColor = .secondaryLabel, clickable: Bool = false) {
        self.init(frame: .zero)
        configure(textAlignment: textAlignment, color: color, fontSize: fontSize, clickable: clickable)
    }
    
    
    private func configure(textAlignment: NSTextAlignment, color: UIColor, fontSize: CGFloat, clickable: Bool) {
        self.textAlignment                  = textAlignment
        textColor                           = color
        font                                = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        adjustsFontForContentSizeCategory   = true
        adjustsFontSizeToFitWidth           = true
        minimumScaleFactor                  = 0.75
        lineBreakMode                       = .byWordWrapping
        isUserInteractionEnabled            = clickable
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        onClick()
    }
}
