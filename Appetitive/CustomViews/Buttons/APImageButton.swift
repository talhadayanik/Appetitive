//
//  APPlusMinusButton.swift
//  Appetitive
//
//  Created by Talha Dayanık on 25.05.2024.
//

import UIKit

protocol APImageButtonDelegate {
    func onClick(indexPath: IndexPath)
}

class APImageButton: UIButton {
    
    var indexPath: IndexPath?
    
    var delegate: APImageButtonDelegate?
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(backgroundColor: UIColor, imageTintColor: UIColor, image: UIImage) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setImage(image, for: .normal)
        self.imageView?.tintColor = imageTintColor
    }
    
    
    private func configure() {
        layer.cornerRadius  = 10
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func set(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if indexPath != nil, delegate != nil {
            delegate!.onClick(indexPath: indexPath!)
        }
    }
}
