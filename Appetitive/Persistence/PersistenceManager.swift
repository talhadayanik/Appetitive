//
//  PersistenceManager.swift
//  Appetitive
//
//  Created by Talha Dayanık on 28.05.2024.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    
    static private let defaults         = UserDefaults.standard
    enum Keys { static let favorites    = "favorites" }
    
    
    static func updateWith(favorite: Yemek, actionType: PersistenceActionType, completion: @escaping (APError?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(var favorites):
                
                switch actionType {
                case .add:
                    favorites.append(favorite)
                    
                case .remove:
                    favorites.removeAll { $0.yemek_id == favorite.yemek_id }
                }
                
                completion(save(favorites: favorites))
                
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    
    static func retrieveFavorites(completion: @escaping (Result<[Yemek], APError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completion(.success([]))
            return
        }
        
        do {
            let decoder     = JSONDecoder()
            let favorites   = try decoder.decode([Yemek].self, from: favoritesData)
            completion(.success(favorites))
        } catch {
            completion(.failure(.unableToFavorite))
        }
    }
    
    
    static func save(favorites: [Yemek]) -> APError? {
        do {
            let encoder             = JSONEncoder()
            let encodedFavorites    = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
}

