//
//  DetailViewModel.swift
//  Appetitive
//
//  Created by Talha Dayanık on 24.05.2024.
//

import Foundation
import RxSwift

final class DetailViewModel {
    
    let itemRepo = ItemRepository()
    var cartItems = BehaviorSubject<[SepetYemek]>(value: [SepetYemek]())
    
    
    init() {
        cartItems = itemRepo.cartItems
    }
    
    
    func getItemImage(for itemImage: APItemImageView, imageUrl: String) {
        itemImage.downloadImage(with: imageUrl)
    }
    
    
    func addToCart(item: Yemek, count: Int, username: String) {
        itemRepo.getAllCart() { [weak self] _ in
            guard let self = self else { return }
            
            do {
                let tCartItems = try self.cartItems.value()
                var isDuplicated = false
                for cartItem in tCartItems {
                    if cartItem.yemek_adi == item.yemek_adi {
                        isDuplicated = true
                        let sum = Int(cartItem.yemek_siparis_adet!)! + count
                        self.itemRepo.removeFromCart(item: cartItem) { _ in }
                        self.itemRepo.addToCart(item: item, count: sum, username: username)
                    }
                }
                
                if !isDuplicated {
                    self.itemRepo.addToCart(item: item, count: count, username: username)
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    func favoriteAction(item: Yemek, actionType: PersistenceActionType) {
        PersistenceManager.updateWith(favorite: item, actionType: actionType) { _ in }
    }
}
