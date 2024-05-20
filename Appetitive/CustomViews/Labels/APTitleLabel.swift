//
//  APTitleLabel.swift
//  Appetitive
//
//  Created by Talha Dayanık on 21.05.2024.
//

import UIKit

class APTitleLabel: UILabel {
    
    var onClick: () -> Void = {}

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat, color: UIColor = .label, clickable: Bool = false) {
        self.init(frame: .zero)
        self.textAlignment  = textAlignment
        self.font           = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        configure(color: color, clickable: clickable)
    }
    
    
    private func configure(color: UIColor, clickable: Bool) {
        textColor                   = color
        adjustsFontSizeToFitWidth   = true
        minimumScaleFactor          = 0.9
        lineBreakMode               = .byTruncatingTail
        isUserInteractionEnabled    = clickable
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        onClick()
    }
}
