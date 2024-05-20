//
//  APTextField.swift
//  Appetitive
//
//  Created by Talha Dayanık on 21.05.2024.
//

import UIKit

class APTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    convenience init(placeholder: String, isSecure: Bool) {
        self.init(frame: .zero)
        configure(placeholderText: placeholder, isSecure: isSecure)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure(placeholderText: String, isSecure: Bool) {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius          = 10
        layer.borderWidth           = 2
        layer.borderColor           = UIColor.systemGray4.cgColor
        
        textColor                   = .label
        tintColor                   = .label
        textAlignment               = .center
        font                        = UIFont.preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth   = true
        minimumFontSize             = 12
        
        backgroundColor             = .tertiarySystemBackground
        autocorrectionType          = .no
        returnKeyType               = .go
        clearButtonMode             = .whileEditing
        placeholder                 = placeholderText
        isSecureTextEntry           = isSecure
    }
}
