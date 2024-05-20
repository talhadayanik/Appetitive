//
//  APItemImageView.swift
//  Appetitive
//
//  Created by Talha Dayanık on 23.05.2024.
//

import UIKit

class APItemImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        layer.cornerRadius  = 10
        clipsToBounds       = true
        contentMode         = .scaleAspectFit
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func downloadImage(with name: String) {
        ItemRepository().getItemImage(for: self, with: name)
    }
}
