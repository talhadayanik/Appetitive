//
//  UIHelper.swift
//  Appetitive
//
//  Created by Talha Dayanık on 23.05.2024.
//

import UIKit

enum UIHelper {
     
    static func sortButtonCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        let screenWidth                 = UIScreen.main.bounds.width
        let horizontalSpace: CGFloat    = 0
        let itemCount: CGFloat          = 3
        let itemWidth                   = (screenWidth - horizontalSpace) / itemCount
        
        flowLayout.itemSize = CGSize(width: itemWidth, height: 40)
        flowLayout.minimumLineSpacing = 1
        return flowLayout
    }
    
    
    static func itemsCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        
        let padding: CGFloat            = 12
        let screenWidth                 = UIScreen.main.bounds.width
        let horizontalSpace: CGFloat    = 10 + padding * 2
        let itemCount: CGFloat          = 2
        let itemWidth                   = (screenWidth - horizontalSpace) / itemCount
        
        flowLayout.sectionInset         = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: 250)
        return flowLayout
    }
    
    
    static func cartCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        
        let padding: CGFloat            = 12
        let screenWidth                 = UIScreen.main.bounds.width
        let horizontalSpace: CGFloat    = padding * 2
        let itemCount: CGFloat          = 1
        let itemWidth                   = (screenWidth - horizontalSpace) / itemCount
        
        flowLayout.sectionInset         = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize             = CGSize(width: itemWidth, height: 250)
        return flowLayout
    }
    
    
    static func setNavigationBarAppearance(vc: UIViewController, font: UIFont, color: UIColor) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor      = .systemBackground
        appearance.titleTextAttributes  = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font]
        
        vc.navigationItem.standardAppearance    = appearance
        vc.navigationItem.scrollEdgeAppearance  = appearance
        vc.navigationItem.compactAppearance     = appearance
    }
    
    
    enum MenuBarAlignment {
        case left
        case right
    }
}
