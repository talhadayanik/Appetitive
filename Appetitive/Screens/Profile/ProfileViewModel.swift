//
//  ProfileViewModel.swift
//  Appetitive
//
//  Created by Talha Dayanık on 22.05.2024.
//

import Foundation
import FirebaseAuth

final class ProfileViewModel {
    
    func signOut(completion: @escaping (Bool) -> Void) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            completion(true)
        } catch {
            print(error.localizedDescription)
            completion(false)
        }
    }
}
