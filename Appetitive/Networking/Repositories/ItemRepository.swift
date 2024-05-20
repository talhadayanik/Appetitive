//
//  ItemRepository.swift
//  Appetitive
//
//  Created by Talha Dayanık on 23.05.2024.
//

import UIKit
import RxSwift
import Alamofire
import Kingfisher

class ItemRepository {
    
    private let baseURL = "http://kasimadalan.pe.hu/yemekler/"
    
    var items           = BehaviorSubject<[Yemek]>(value: [Yemek]())
    var cartItems       = BehaviorSubject<[SepetYemek]>(value: [SepetYemek]())
    
    let serialQueue     = DispatchQueue(label: "serialQueue")
    let dispatchGroup   = DispatchGroup()
    
    
    func getAll(completion: @escaping (_ success: Bool) -> Void) {
        let url = URL(string: baseURL + "tumYemekleriGetir.php")!
        
        AF.request(url, method: .get).response { response in
            guard response.error == nil else { return }
            
            if let data = response.data {
                do {
                    let parsedObject = try JSONDecoder().decode(GetAllModel.self, from: data)
                    if let itemList = parsedObject.yemekler {
                        self.items.onNext(itemList)
                        completion(true)
                    }
                } catch {
                    print(error.localizedDescription)
                    completion(false)
                }
            }
        }
    }
    
    
    func getAllCart(completion: @escaping (_ success: Bool) -> Void) {
        let url = URL(string: baseURL + "sepettekiYemekleriGetir.php")!
        let params: Parameters = ["kullanici_adi":AuthManager.shared.currentUser!.uid]
        
        AF.request(url, method: .post, parameters: params).response { response in
            guard response.error == nil else { return }
            
            if let data = response.data {
                do {
                    let parsedObject = try JSONDecoder().decode(CartModel.self, from: data)
                    if let itemList = parsedObject.sepet_yemekler {
                        self.cartItems.onNext(itemList)
                        completion(true)
                    }
                } catch {
                    print(error.localizedDescription)
                    // API sends an empty body when cart is empty
                    self.cartItems.onNext([SepetYemek]())
                    completion(true)
                }
            }
        }
    }
    
    
    func removeFromCart(item: SepetYemek, completion: @escaping (_ success: Bool) -> Void) {
        dispatchGroup.enter()
        let url = URL(string: baseURL + "sepettenYemekSil.php")!
        let params: Parameters = ["sepet_yemek_id": item.sepet_yemek_id!, "kullanici_adi":AuthManager.shared.currentUser!.uid]
        
        AF.request(url, method: .post, parameters: params).response { response in
            guard response.error == nil else { return }
            
            if let data = response.data {
                do {
                    let res = try JSONDecoder().decode(CRUDResponse.self, from: data)
                    print("Başarı : \(res.success!)")
                    print("Mesaj  : \(res.message!)")
                    completion(true)
                    
                } catch {
                    print(error.localizedDescription)
                    completion(false)
                }
            }
            self.dispatchGroup.leave()
        }
    }
    
    
    func removeAllFromCart(completion: @escaping (_ success: Bool) -> Void) {
        
        do {
            let tCartItems = try cartItems.value()
            for item in tCartItems {
                removeFromCart(item: item) { _ in }
            }
            dispatchGroup.notify(queue: serialQueue) {
                self.getAllCart() { _ in }
            }
            completion(true)
        } catch {
            print(error.localizedDescription)
            completion(false)
        }
    }
    
    
    func getItemImage(for itemIV: APItemImageView, with name: String) {
        DispatchQueue.main.async {
            if let url = URL(string: self.baseURL + "resimler/\(name)") {
                itemIV.kf.setImage(with: url)
            }
        }
    }
    
    
    func addToCart(item: Yemek, count: Int, username: String) {
        let url = URL(string: baseURL + "sepeteYemekEkle.php")!
        let params: Parameters = ["yemek_adi": item.yemek_adi!, "yemek_resim_adi": item.yemek_resim_adi!, "yemek_fiyat": item.yemek_fiyat!, "yemek_siparis_adet": count, "kullanici_adi": username]
        
        AF.request(url, method: .post, parameters: params).response { response in
            guard response.error == nil else { return }
            
            if let data = response.data {
                do{
                    let res = try JSONDecoder().decode(CRUDResponse.self, from: data)
                    print("Başarı : \(res.success!)")
                    print("Mesaj  : \(res.message!)")
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
}
