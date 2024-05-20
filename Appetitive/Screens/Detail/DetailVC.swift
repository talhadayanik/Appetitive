//
//  DetailVC.swift
//  Appetitive
//
//  Created by Talha Dayanık on 24.05.2024.
//

import UIKit

protocol DetailVCDelegate {
    func onDismiss()
}

class DetailVC: UIViewController {
    
    let itemImageView       = APItemImageView(frame: .zero)
    let itemNameLabel       = APTitleLabel(textAlignment: .center, fontSize: 36)
    let itemCountLabel      = APBodyLabel(textAlignment: .center, fontSize: 16)
    let plusButton          = APImageButton(backgroundColor: .systemPink, imageTintColor: .systemBackground, image: SFSymbols.plusButtonImage!)
    let minusButton         = APImageButton(backgroundColor: .systemGray3, imageTintColor: .systemBackground, image: SFSymbols.minusButtonImage!)
    let sumContainerView    = UIView(frame: .zero)
    let sumLabel            = APTitleLabel(textAlignment: .center, fontSize: 24)
    let sumPriceLabel       = APTitleLabel(textAlignment: .center, fontSize: 24, color: .systemPink)
    let addToCartButton     = APButton(backgroundColor: .systemPink, title: "Sepete Ekle")
    
    var viewModel = DetailViewModel()
    var selectedItem: Yemek?
    var isFavorited: Bool?
    
    var delegate: DetailVCDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UIHelper.setNavigationBarAppearance(vc: self, font: UIFont.systemFont(ofSize: 26, weight: .bold), color: .systemPink)
        
        self.navigationItem.title = "Ürün Detayı"
        self.navigationController?.navigationBar.tintColor = .systemPink
        
        checkIfItsFavorited()
        configureBarButtonItem(image: SFSymbols.backButtonImage!, alignment: .left, action: #selector(backButtonPressed))
        let favImage = isFavorited! ? SFSymbols.favFilledButtonImage : SFSymbols.favButtonImage
        configureBarButtonItem(image: favImage!, alignment: .right, action: #selector(favButtonPressed))
        configureItemImageView()
        configureItemNameLabel()
        configureItemCountLabel()
        configurePlusMinusButtons()
        configureSumContainerAndLabels()
        configureAddToCartButton()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presentingViewController?.viewWillAppear(true)
    }
    
    
    private func configureItemImageView() {
        view.addSubview(itemImageView)
        viewModel.getItemImage(for: itemImageView, imageUrl: selectedItem!.yemek_resim_adi!)
        
        NSLayoutConstraint.activate([
            itemImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            itemImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            itemImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            itemImageView.widthAnchor.constraint(equalToConstant: 256),
            itemImageView.heightAnchor.constraint(equalToConstant: 256)
        ])
    }
    
    
    private func configureItemNameLabel() {
        view.addSubview(itemNameLabel)
        itemNameLabel.text = selectedItem?.yemek_adi
        
        NSLayoutConstraint.activate([
            itemNameLabel.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 16),
            itemNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    private func configureItemCountLabel() {
        view.addSubview(itemCountLabel)
        itemCountLabel.font = UIFont.systemFont(ofSize: 52, weight: .medium)
        itemCountLabel.textColor = .systemPink
        itemCountLabel.text = "1"
        
        NSLayoutConstraint.activate([
            itemCountLabel.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor, constant: 32),
            itemCountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    private func configurePlusMinusButtons() {
        view.addSubviews(plusButton, minusButton)
        minusButton.addTarget(self, action: #selector(minusButtonPressed), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(plusButtonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            minusButton.centerYAnchor.constraint(equalTo: itemCountLabel.centerYAnchor),
            minusButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 96),
            minusButton.widthAnchor.constraint(equalToConstant: 50),
            minusButton.heightAnchor.constraint(equalToConstant: 50),
            
            plusButton.centerYAnchor.constraint(equalTo: itemCountLabel.centerYAnchor),
            plusButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -96),
            plusButton.widthAnchor.constraint(equalToConstant: 50),
            plusButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    private func configureSumContainerAndLabels() {
        sumContainerView.addSubviews(sumLabel, sumPriceLabel)
        view.addSubview(sumContainerView)
        sumLabel.text = "\(itemCountLabel.text!) Adet Toplam:"
        sumPriceLabel.text = "\(selectedItem!.yemek_fiyat!) ₺"
        sumContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sumContainerView.topAnchor.constraint(equalTo: itemCountLabel.bottomAnchor, constant: 64),
            sumContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            sumLabel.centerYAnchor.constraint(equalTo: sumContainerView.centerYAnchor),
            sumLabel.leadingAnchor.constraint(equalTo: sumContainerView.leadingAnchor, constant: 16),
            
            sumPriceLabel.centerYAnchor.constraint(equalTo: sumContainerView.centerYAnchor),
            sumPriceLabel.leadingAnchor.constraint(equalTo: sumLabel.trailingAnchor, constant: 12),
            sumPriceLabel.trailingAnchor.constraint(equalTo: sumContainerView.trailingAnchor, constant: -16)
        ])
    }
    
    
    private func configureAddToCartButton() {
        view.addSubview(addToCartButton)
        
        addToCartButton.addTarget(self, action: #selector(addToCartButtonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            addToCartButton.topAnchor.constraint(equalTo: sumContainerView.bottomAnchor, constant: 64),
            addToCartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addToCartButton.widthAnchor.constraint(equalToConstant: 150),
            addToCartButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    @objc private func minusButtonPressed() {
        if Int(itemCountLabel.text!)! > 1 {
            itemCountLabel.text = String(Int(itemCountLabel.text!)! - 1)
            sumLabel.text = "\(itemCountLabel.text!) Adet Toplam:"
            sumPriceLabel.text = "\(Int(selectedItem!.yemek_fiyat!)! * Int(itemCountLabel.text!)!) ₺"
            if Int(itemCountLabel.text!)! == 1 {
                minusButton.set(backgroundColor: .systemGray3)
            }
        }
    }
    
    
    @objc private func plusButtonPressed() {
        itemCountLabel.text = String(Int(itemCountLabel.text!)! + 1)
        sumLabel.text = "\(itemCountLabel.text!) Adet Toplam:"
        sumPriceLabel.text = "\(Int(selectedItem!.yemek_fiyat!)! * Int(itemCountLabel.text!)!) ₺"
        minusButton.set(backgroundColor: .systemPink)
    }
    
    
    @objc private func addToCartButtonPressed() {
        let count = Int(itemCountLabel.text!)!
        let username = AuthManager.shared.currentUser?.uid
        viewModel.addToCart(item: selectedItem!, count: count, username: username!)
        presentingViewController?.showToast(message: "Sepete eklendi.", font: .boldSystemFont(ofSize: 14))
        dismiss(animated: true)
    }
    
    
    private func configureBarButtonItem(image: UIImage, alignment: UIHelper.MenuBarAlignment, action: Selector){
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 36, height: 36)
        menuBtn.setImage(image, for: .normal)
        menuBtn.imageView?.contentMode = .scaleAspectFit
        menuBtn.imageView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuBtn.imageView!.widthAnchor.constraint(equalToConstant: 36),
            menuBtn.imageView!.heightAnchor.constraint(equalToConstant: 36)
        ])
        menuBtn.addTarget(self, action: action, for: .touchUpInside)

        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 80)
        currWidth?.isActive = true
        
        if alignment == .left {
            self.navigationItem.leftBarButtonItem = menuBarItem
        } else {
            self.navigationItem.rightBarButtonItem = menuBarItem
        }
    }
    
    
    @objc private func favButtonPressed() {
        viewModel.favoriteAction(item: selectedItem!, actionType: (isFavorited! ? .remove : .add))
        isFavorited = !isFavorited!
        navigationItem.rightBarButtonItems?.removeAll()
        let favImage = isFavorited! ? SFSymbols.favFilledButtonImage : SFSymbols.favButtonImage
        configureBarButtonItem(image: favImage!, alignment: .right, action: #selector(favButtonPressed))
    }
    
    
    @objc private func backButtonPressed() {
        dismiss(animated: true)
    }
    
    
    private func checkIfItsFavorited() {
        PersistenceManager.retrieveFavorites { result in
            switch result {
            case .success(let favorites):
                if favorites.contains(self.selectedItem!) {
                    self.isFavorited = true
                } else {
                    self.isFavorited = false
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.onDismiss()
    }
}


extension DetailVC: APAlertVCDelegate {
    
    func alertActionButtonPressed() {
        dismiss(animated: true)
    }
}
