//
//  CartViewModel.swift
//  Appetitive
//
//  Created by Talha Dayanık on 25.05.2024.
//

import Foundation
import RxSwift

final class CartViewModel {
    
    var itemRepo = ItemRepository()
    var items = BehaviorSubject<[SepetYemek]>(value: [SepetYemek]())
    
    
    init() {
        items = itemRepo.cartItems
    }
    
    
    func getAllCart() {
        itemRepo.getAllCart() { _ in }
    }
    
    
    func removeAllFromCart(completion: @escaping () -> Void) {
        itemRepo.removeAllFromCart() { _ in 
            completion()}
    }
    
    
    func removeFromCart(item: SepetYemek, completion: @escaping () -> Void) {
        itemRepo.removeFromCart(item: item) { _ in
            completion()
        }
    }
    
    
    func getTotalPrice() -> Int {
        var total = 0
        do {
            let tItems = try items.value()
            for item in tItems {
                let sum = Int(item.yemek_fiyat!)! * Int(item.yemek_siparis_adet!)!
                total += sum
            }
            return total
        } catch {
            print(error.localizedDescription)
            return 0
        }
    }
}
