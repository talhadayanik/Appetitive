//
//  APSortButton.swift
//  Appetitive
//
//  Created by Talha Dayanık on 23.05.2024.
//

import UIKit

protocol APSortButtonDelegate {
    func onClick(title: String, indexPath: IndexPath)
}

enum SortButton: String {
    case increasing = "increasing"
    case decreasing = "decreasing"
    case favorites  = "favorites"
}

class APSortButton: UIButton {
    
    var delegate: APSortButtonDelegate!
    var indexPath: IndexPath!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(title: String) {
        self.init(frame: .zero)
        self.setTitle(title, for: .normal)
    }
    
    
    private func configure() {
        layer.cornerRadius  = 20
        layer.borderColor   = UIColor.systemPink.cgColor
        layer.borderWidth   = 3
        setTitleColor(.systemPink, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 110),
            self.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        delegate.onClick(title: currentTitle!, indexPath: indexPath)
    }
}
