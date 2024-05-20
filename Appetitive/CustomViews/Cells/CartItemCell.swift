//
//  CartItemCell.swift
//  Appetitive
//
//  Created by Talha Dayanık on 25.05.2024.
//

import UIKit

class CartItemCell: UICollectionViewCell {
    
    static let reuseID = "CartItemCell"
    
    let containerView   = UIView(frame: .zero)
    let itemImageView   = APItemImageView(frame: .zero)
    let itemNameLabel   = APTitleLabel(textAlignment: .left, fontSize: 24)
    let priceLabel      = APBodyLabel(textAlignment: .left, fontSize: 20)
    let itemPriceLabel  = APTitleLabel(textAlignment: .left, fontSize: 24, color: .systemPink)
    let countLabel      = APBodyLabel(textAlignment: .left, fontSize: 20)
    let itemCountLabel  = APTitleLabel(textAlignment: .left, fontSize: 24)
    let sumLabel        = APBodyLabel(textAlignment: .left, fontSize: 20)
    let itemSumLabel    = APTitleLabel(textAlignment: .left, fontSize: 24, color: .systemPink)
    let deleteButton    = APImageButton(backgroundColor: .systemPink, imageTintColor: .systemBackground, image: SFSymbols.deleteButton!)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(item: SepetYemek) {
        itemImageView.downloadImage(with: item.yemek_resim_adi!)
        itemNameLabel.text  = item.yemek_adi
        itemPriceLabel.text = "\(item.yemek_fiyat!) ₺"
        itemCountLabel.text = item.yemek_siparis_adet
        itemSumLabel.text   = "\(String(Int(item.yemek_fiyat!)! * Int(item.yemek_siparis_adet!)!)) ₺"
    }
    
    
    private func configure() {
        addSubviews(containerView, itemImageView, itemNameLabel, priceLabel, itemPriceLabel, countLabel, itemCountLabel, sumLabel, itemSumLabel, deleteButton)
        let padding: CGFloat = 8
        
        priceLabel.text = "Fiyat: "
        countLabel.text = "Adet: "
        sumLabel.text   = "Toplam: "
        
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
            
            itemImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
            itemImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            itemImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -32),
            itemImageView.widthAnchor.constraint(equalTo: itemImageView.heightAnchor),
            
            itemNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            itemNameLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: padding),
            
            priceLabel.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor, constant: 16),
            priceLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: padding),
            
            itemPriceLabel.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            itemPriceLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: padding),
            
            countLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16),
            countLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: padding),
            
            itemCountLabel.centerYAnchor.constraint(equalTo: countLabel.centerYAnchor),
            itemCountLabel.leadingAnchor.constraint(equalTo: countLabel.trailingAnchor, constant: padding),
            
            sumLabel.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: 16),
            sumLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: padding),
            
            itemSumLabel.centerYAnchor.constraint(equalTo: sumLabel.centerYAnchor),
            itemSumLabel.leadingAnchor.constraint(equalTo: sumLabel.trailingAnchor, constant: padding),
            
            deleteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            deleteButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            deleteButton.widthAnchor.constraint(equalToConstant: 52),
            deleteButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
}
