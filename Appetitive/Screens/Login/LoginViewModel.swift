//
//  LoginViewModel.swift
//  Appetitive
//
//  Created by Talha Dayanık on 21.05.2024.
//

import Foundation
import FirebaseAuth

final class LoginViewModel {
    
    func signIn(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { result, error in
            completion(result, error)
        }
    }
    
    
    func signUp(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { result, error in
            completion(result, error)
        }
    }
    
    
    func getCurrentUser() -> User? {
        return FirebaseAuth.Auth.auth().currentUser
    }
}
