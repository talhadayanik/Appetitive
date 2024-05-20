//
//  ItemCell.swift
//  Appetitive
//
//  Created by Talha Dayanık on 23.05.2024.
//

import UIKit

class ItemCell: UICollectionViewCell {
    
    static let reuseID = "ItemCell"
    
    let containerView   = UIView(frame: .zero)
    let itemImageView   = APItemImageView(frame: .zero)
    let itemNameLabel   = APTitleLabel(textAlignment: .left, fontSize: 20)
    let itemPriceLabel  = APTitleLabel(textAlignment: .center, fontSize: 32, color: .systemPink)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(item: Yemek) {
        itemImageView.downloadImage(with: item.yemek_resim_adi!)
        itemNameLabel.text  = item.yemek_adi
        itemPriceLabel.text = "\(item.yemek_fiyat!) ₺"
    }
    
    
    private func configure() {
        addSubviews(containerView, itemImageView, itemNameLabel, itemPriceLabel)
        let padding: CGFloat = 8
        
        containerView.backgroundColor       = .systemBackground
        containerView.layer.cornerRadius    = 16
        containerView.layer.borderWidth     = 1
        containerView.layer.borderColor     = UIColor.systemPink.cgColor
        containerView.layer.shadowColor     = UIColor.black.cgColor
        containerView.layer.shadowOpacity   = 0.2
        containerView.layer.shadowOffset    = CGSize(width: 4, height: 4)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            
            itemImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            itemImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            itemImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            itemImageView.heightAnchor.constraint(equalTo: itemImageView.widthAnchor),
            
            itemNameLabel.topAnchor.constraint(equalTo: itemImageView.bottomAnchor),
            itemNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding * 3),
            
            itemPriceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: padding * -3),
            itemPriceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            itemPriceLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
