//
//  SortButtonCell.swift
//  Appetitive
//
//  Created by Talha Dayanık on 23.05.2024.
//

import UIKit

class SortButtonCell: UICollectionViewCell {
    
    static let reuseID  = "SortButtonCell"
    
    let button          = APSortButton(title: "")
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(title: String) {
        self.init(frame: .zero)
        configure(title: title)
    }
    
    
    public func configure(title: String) {
        addSubview(button)
        button.setTitle(title, for: .normal)
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            button.heightAnchor.constraint(equalToConstant: 35),
        ])
    }
}
