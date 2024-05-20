//
//  HomepageVC.swift
//  Appetitive
//
//  Created by Talha Dayanık on 21.05.2024.
//

import UIKit

class HomepageVC: UIViewController, LoadingShowable, UIAdaptivePresentationControllerDelegate {
    
    enum Section { case main }
    
    let titleLabel      = APTitleLabel(textAlignment: .left, fontSize: 26, color: .systemPink)
    let searchBar       = UISearchBar()
    
    var sortButtonCollectionView: UICollectionView!
    var sortButtons     = ["Artan", "Azalan", "Favoriler"]
    var selectedButton  = ""
    
    var itemsCollectionView: UICollectionView!
    var itemsDataSource: UICollectionViewDiffableDataSource<Section, Yemek>!
    
    var items           = [Yemek]()
    var searchItems     = [Yemek]()
    var filteredItems   = [Yemek]()
    var isSearching     = false
    
    var isFiltering: (Bool, SortButton) = (false, .increasing)
    
    var viewModel = HomepageViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureCollectionViewTitleLabel()
        configureSearchBar()
        configureSortButtonCollectionView()
        configureItemsCollectionView()
        getItems()
        configureDataSource()
        createDismissKeyboardTapGesture()
        
        _ = viewModel.items.subscribe(onNext: { itemList in
            self.items = itemList
            self.updateData(on: self.items)
            self.hideLoading()
        })
        
        _ = viewModel.filteredItems.subscribe(onNext: { itemList in
            self.filteredItems = itemList
            self.updateData(on: self.filteredItems)
        })
        
        _ = viewModel.searchItems.subscribe(onNext: { itemList in
            self.searchItems = itemList
            self.updateData(on: self.searchItems)
        })
    }
    
    
    private func configureCollectionViewTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.text = "Ürünler:"
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.widthAnchor.constraint(equalToConstant: 500),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    
    private func configureSearchBar() {
        view.addSubview(searchBar)
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        searchBar.searchTextField.textColor = .systemPink
        searchBar.backgroundImage = UIImage()
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            searchBar.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    
    private func configureSortButtonCollectionView() {
        sortButtonCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.sortButtonCollectionViewFlowLayout())
        view.addSubview(sortButtonCollectionView)
        sortButtonCollectionView.delegate = self
        sortButtonCollectionView.dataSource = self
        sortButtonCollectionView.backgroundColor = .systemBackground
        sortButtonCollectionView.register(SortButtonCell.self, forCellWithReuseIdentifier: SortButtonCell.reuseID)
        sortButtonCollectionView.showsHorizontalScrollIndicator = false
        sortButtonCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sortButtonCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            sortButtonCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sortButtonCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sortButtonCollectionView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    private func configureItemsCollectionView() {
        
        itemsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.itemsCollectionViewFlowLayout())
        view.addSubview(itemsCollectionView)
        itemsCollectionView.delegate = self
        itemsCollectionView.backgroundColor = .systemBackground
        itemsCollectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.reuseID)
        itemsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        itemsCollectionView.delaysContentTouches = false
        
        NSLayoutConstraint.activate([
            itemsCollectionView.topAnchor.constraint(equalTo: sortButtonCollectionView.bottomAnchor, constant: 8),
            itemsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            itemsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            itemsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    private func configureDataSource() {
        itemsDataSource = UICollectionViewDiffableDataSource<Section, Yemek>(collectionView: itemsCollectionView, cellProvider: { collectionView, indexPath, item in
            let cell = self.itemsCollectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.reuseID, for: indexPath) as! ItemCell
            cell.set(item: item)
            return cell
        })
    }
    
    
    private func updateData(on itemList: [Yemek]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Yemek>()
        snapshot.appendSections([.main])
        snapshot.appendItems(itemList)
        DispatchQueue.main.async { self.itemsDataSource.apply(snapshot, animatingDifferences: true) }
    }
    
    
    private func getItems() {
        self.showLoading()
        viewModel.getAll()
    }
    
    
    private func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}


extension HomepageVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.sortButtonCollectionView {
            return sortButtons.count
        } else {
            return items.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.sortButtonCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SortButtonCell.reuseID, for: indexPath) as! SortButtonCell
            
            cell.configure(title: sortButtons[indexPath.row])
            cell.contentView.isUserInteractionEnabled = false
            cell.button.delegate = self
            cell.button.indexPath = indexPath
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.reuseID, for: indexPath) as! ItemCell
            
            cell.set(item: items[indexPath.row])
            
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.itemsCollectionView {
            var activeArray = [Yemek]()
            
            if isFiltering.0 {
                activeArray = filteredItems
            } else if isSearching {
                activeArray = searchItems
            } else {
                activeArray = items
            }
            
            let detailVC = DetailVC()
            detailVC.selectedItem = activeArray[indexPath.row]
            detailVC.delegate = self
            self.present(UINavigationController(rootViewController: detailVC), animated: true)
        }
    }
}


extension HomepageVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let filter = searchBar.text, !filter.isEmpty else {
            isSearching = false
            viewModel.removeAllSearchItems() { [weak self] in
                guard let self = self else { return }
                
                if isFiltering.0 {
                    viewModel.filterItems(isSearching: isSearching, sortOrder: isFiltering.1)
                } else {
                    updateData(on: items)
                }
            }
            return
        }
        
        isSearching = true
        if isFiltering.0 {
            viewModel.searchItems(filter: filter) { [weak self] in
                guard let self = self else { return }
                
                self.viewModel.filterItems(isSearching: self.isSearching, sortOrder: self.isFiltering.1)
            }
        } else {
            viewModel.searchItems(filter: filter) {}
        }
    }
}


extension HomepageVC: APSortButtonDelegate {
    
    func onClick(title: String, indexPath: IndexPath) {
        if selectedButton != title {
            selectedButton = title
            for cell in sortButtonCollectionView.visibleCells as! [SortButtonCell] {
                if cell.button.currentTitle == title {
                    cell.button.backgroundColor = .systemPink
                    cell.button.setTitleColor(.systemBackground, for: .normal)
                    if cell.button.currentTitle == "Artan" {
                        viewModel.filterItems(isSearching: isSearching, sortOrder: .increasing)
                        isFiltering.0 = true
                        isFiltering.1 = .increasing
                    } else if cell.button.currentTitle == "Azalan" {
                        viewModel.filterItems(isSearching: isSearching, sortOrder: .decreasing)
                        isFiltering.0 = true
                        isFiltering.1 = .decreasing
                    } else {
                        viewModel.filterItems(isSearching: isSearching, sortOrder: .favorites)
                        isFiltering.0 = true
                        isFiltering.1 = .favorites
                    }
                } else {
                    cell.button.backgroundColor = .systemBackground
                    cell.button.setTitleColor(.systemPink, for: .normal)
                }
            }
        } else {
            selectedButton = ""
            isFiltering.0 = false
            let cell = sortButtonCollectionView.cellForItem(at: indexPath) as! SortButtonCell
            cell.button.backgroundColor = .systemBackground
            cell.button.setTitleColor(.systemPink, for: .normal)
            let activeArray = isSearching ? searchItems : items
            updateData(on: activeArray)
        }
    }
}


extension HomepageVC: DetailVCDelegate {
    func onDismiss() {
        if isFiltering == (true, .favorites) {
            viewModel.filterItems(isSearching: isSearching, sortOrder: .favorites)
        }
    }
}
