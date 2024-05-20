//
//  HomepageViewModel.swift
//  Appetitive
//
//  Created by Talha Dayanık on 21.05.2024.
//

import Foundation
import RxSwift

final class HomepageViewModel {
    
    var itemRepo        = ItemRepository()
    var items           = BehaviorSubject<[Yemek]>(value: [Yemek]())
    var filteredItems   = BehaviorSubject<[Yemek]>(value: [Yemek]())
    var searchItems     = BehaviorSubject<[Yemek]>(value: [Yemek]())
    
    
    init() {
        items = itemRepo.items
    }
    
    
    func getAll() {
        itemRepo.getAll() { _ in }
    }
    
    
    func filterItems(isSearching: Bool, sortOrder: SortButton) {
        filteredItems.onNext([Yemek]())
        var activeArray = [Yemek]()
        
        do {
            let sItems  = try searchItems.value()
            let nItems  = try items.value()
            activeArray = isSearching ? sItems : nItems
        } catch {
            print(error.localizedDescription)
        }
        
        if sortOrder == .increasing {
            activeArray.sort(by: {Int($0.yemek_fiyat!)! < Int($1.yemek_fiyat!)!})
            filteredItems.onNext(activeArray)
        } else if sortOrder == .decreasing {
            activeArray.sort(by: {Int($0.yemek_fiyat!)! > Int($1.yemek_fiyat!)!})
            filteredItems.onNext(activeArray)
        } else if sortOrder == .favorites {
            PersistenceManager.retrieveFavorites { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let favorites):
                    let filteredFavorites = activeArray.filter { favorites.contains($0) }
                    filteredItems.onNext(filteredFavorites)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    func searchItems(filter: String, completion: @escaping () -> Void) {
        do {
            let tempSearchItems = try items.value().filter { $0.yemek_adi!.lowercased().contains(filter.lowercased())}
                searchItems.onNext(tempSearchItems)
                completion()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func removeAllSearchItems(completion: @escaping () -> Void) {
        searchItems.onNext([Yemek]())
        completion()
    }
}
