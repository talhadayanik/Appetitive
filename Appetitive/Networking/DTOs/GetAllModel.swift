//
//  GetAllModel.swift
//  Appetitive
//
//  Created by Talha Dayanık on 23.05.2024.
//

import Foundation

struct GetAllModel: Codable {
    var yemekler: [Yemek]?
    var success: Int?
}


struct Yemek: Codable, Hashable {
    var yemek_id: String?
    var yemek_adi: String?
    var yemek_resim_adi: String?
    var yemek_fiyat: String?
}
