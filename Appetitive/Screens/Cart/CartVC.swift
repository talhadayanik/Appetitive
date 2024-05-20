//
//  CartVC.swift
//  Appetitive
//
//  Created by Talha Dayanık on 25.05.2024.
//

import UIKit

class CartVC: UIViewController, LoadingShowable {
    
    let totalLabel          = APBodyLabel(textAlignment: .left, fontSize: 24, color: .systemPink)
    let totalPriceLabel     = APBodyLabel(textAlignment: .left, fontSize: 24, color: .systemPink)
    let locationImageView   = UIImageView(frame: .zero)
    let locationLabel       = APBodyLabel(textAlignment: .left, fontSize: 24, color: .systemPink)
    let emptyCartView       = APEmptyCartView(message: "Sepetiniz boş.")
    
    var collectionView: UICollectionView!
    
    var items = [SepetYemek]()
    
    var viewModel = CartViewModel()
    
    var selectedItemIndexPath: IndexPath?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UIHelper.setNavigationBarAppearance(vc: self, font: UIFont.systemFont(ofSize: 26, weight: .bold), color: .systemPink)
        
        self.navigationItem.title = "Sepet"
        self.navigationController?.navigationBar.tintColor = .systemPink
        configureBarButtonItem(image: SFSymbols.backButtonImage!, alignment: .left, action: #selector(backButtonPressed))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sipariş Ver", style: .plain, target: self, action: #selector(orderButtonPressed))
        
        configureHeader()
        configureCollectionView()
        configureEmptyCartView()
        getItems()
        
        _ = viewModel.items.subscribe(onNext: { itemList in
            self.items = itemList
            self.hideLoading()
            self.collectionView.reloadData()
            self.totalPriceLabel.text = "\(String(self.viewModel.getTotalPrice())) ₺"
            if self.items.isEmpty {
                self.view.bringSubviewToFront(self.emptyCartView)
            } else {
                self.view.bringSubviewToFront(self.collectionView)
            }
        })
    }
    
    
    private func configureHeader() {
        view.addSubviews(locationImageView, locationLabel, totalLabel, totalPriceLabel)
        locationImageView.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.text             = "Genel Toplam: "
        locationImageView.image     = SFSymbols.locationImageView!
        locationImageView.tintColor = .systemPink
        locationLabel.text          = AuthManager.shared.orderLocation
        
        NSLayoutConstraint.activate([
            locationImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            locationImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            locationImageView.widthAnchor.constraint(equalToConstant: 24),
            locationImageView.heightAnchor.constraint(equalTo: locationImageView.widthAnchor),
            
            locationLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 8),
            
            totalPriceLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor),
            totalPriceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            totalLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor),
            totalLabel.trailingAnchor.constraint(equalTo: totalPriceLabel.leadingAnchor, constant: -8)
        ])
    }
    
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.cartCollectionViewFlowLayout())
        view.addSubview(collectionView)
        collectionView.delegate         = self
        collectionView.dataSource       = self
        collectionView.backgroundColor  = .systemBackground
        collectionView.register(CartItemCell.self, forCellWithReuseIdentifier: CartItemCell.reuseID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: locationImageView.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
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
    
    
    private func configureEmptyCartView() {
        emptyCartView.frame = view.bounds
        view.addSubview(emptyCartView)
    }
    
    
    private func getItems() {
        self.showLoading()
        viewModel.getAllCart()
    }
    
    
    @objc func backButtonPressed() {
        dismiss(animated: true)
    }
    
    
    @objc func orderButtonPressed() {
        if !items.isEmpty {
            presentAPActionOnMainThread(title: "Sipariş verilsin mi?", message: "", actionButtonTitle: "Evet", cancelButtonTitle: "İptal", actionVCDelegate: self, type: .siparisVer)
        }
    }
}


extension CartVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CartItemCell.reuseID, for: indexPath) as! CartItemCell
        
        cell.set(item: items[indexPath.row])
        cell.contentView.isUserInteractionEnabled = false
        cell.deleteButton.indexPath = indexPath
        cell.deleteButton.delegate = self
        
        return cell
    }
}


extension CartVC: APImageButtonDelegate {
    //APImageButtonDelegate func for delete button
    func onClick(indexPath: IndexPath) {
        presentAPActionOnMainThread(title: "Yemek Sil", message: "Seçtiğiniz yemek silinsin mi?", actionButtonTitle: "Evet", cancelButtonTitle: "İptal", actionVCDelegate: self, type: .yemekSil)
        selectedItemIndexPath = indexPath
    }
}


extension CartVC: APActionVCDelegate {
    
    func actionButtonPressed(type: APActionVCType) {
        if type == .yemekSil {
            viewModel.removeFromCart(item: items[selectedItemIndexPath!.row]) { [weak self] in
                guard let self = self else { return }
                
                self.getItems()
                self.dismiss(animated: true)
            }
        } else if type == .siparisVer {
            viewModel.removeAllFromCart { [weak self] in
                guard let self = self else { return }
            
                self.presentingViewController?.showToast(message: "Sipariş verildi.", font: .boldSystemFont(ofSize: 14))
                self.presentingViewController?.dismiss(animated: true)
            }
        }
    }
}
