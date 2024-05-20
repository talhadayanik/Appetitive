//
//  CartModel.swift
//  Appetitive
//
//  Created by Talha Dayanık on 25.05.2024.
//

import Foundation

struct CartModel: Codable {
    var sepet_yemekler: [SepetYemek]?
    var success: Int?
}


struct emptyCartModel: Codable {
    
}


struct SepetYemek: Codable, Hashable {
    var sepet_yemek_id: String?
    var yemek_adi: String?
    var yemek_resim_adi: String?
    var yemek_fiyat: String?
    var yemek_siparis_adet: String?
    var kullanici_adi: String?
}
