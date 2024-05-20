//
//  AuthManager.swift
//  Appetitive
//
//  Created by Talha Dayanık on 25.05.2024.
//

import Foundation
import FirebaseAuth

class AuthManager {
    
    static let shared = AuthManager()
    
    var currentUser: User?
    
    var orderLocation = "Evim"
    
    private init() {}
}
