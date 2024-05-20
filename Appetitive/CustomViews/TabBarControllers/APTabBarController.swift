//
//  APTabBarController.swift
//  Appetitive
//
//  Created by Talha Dayanık on 21.05.2024.
//

import UIKit

class APTabBarController: UITabBarController {
    
    let middleButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle     = .fullScreen
        UITabBar.appearance().tintColor = .systemPink
        viewControllers                 = [createHomepageNC(), createProfileNC()]
    }
    
    
    override func loadView() {
        super.loadView()
        self.tabBar.addSubview(middleButton)
        configureCustomTabBar()
        configureMiddleButton()
    }
    
    
    func createHomepageNC() -> UINavigationController {
        let homepageVC          = HomepageVC()
        homepageVC.title        = "Appetitive"
        homepageVC.tabBarItem   = UITabBarItem(title: "Home", image: SFSymbols.homepageTabBarItemImage, tag: 0)
        
        return UINavigationController(rootViewController: homepageVC)
    }
    
    
    func createProfileNC() -> UINavigationController {
        let profileVC           = ProfileVC()
        profileVC.title         = "Appetitive"
        profileVC.tabBarItem    = UITabBarItem(title: "Profile", image: SFSymbols.profileTabBarItemImage, tag: 0)
        
        return UINavigationController(rootViewController: profileVC)
    }
    
    
    func configureMiddleButton() {
        middleButton.setTitle("", for: .normal)
        middleButton.backgroundColor = .systemPink
        middleButton.layer.cornerRadius = 30
        middleButton.layer.shadowColor = UIColor.black.cgColor
        middleButton.layer.shadowOpacity = 0.2
        middleButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        middleButton.setImage(SFSymbols.cartTabBarItemImage, for: .normal)
        middleButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 28), forImageIn: .normal)
        middleButton.contentMode = .center
        middleButton.tintColor = .systemBackground
        middleButton.frame = CGRect(x: Int(self.tabBar.bounds.width) / 2 - 30, y: -20, width: 60, height: 60)
        middleButton.addTarget(self, action: #selector(middleButtonPressed), for: .touchUpInside)
    }
    
    
    @objc func middleButtonPressed() {
        let cartVC = CartVC()
        self.present(UINavigationController(rootViewController: cartVC), animated: true)
    }
    
    
    func configureCustomTabBar() {
        let path: UIBezierPath  = getPathForTabBar()
        let shape               = CAShapeLayer()
        shape.path              = path.cgPath
        shape.lineWidth         = 3
        shape.strokeColor       = UIColor.systemPink.cgColor
        shape.fillColor         = UIColor.systemBackground.cgColor
        self.tabBar.layer.insertSublayer(shape, at: 0)
        
        self.tabBar.itemWidth       = 150
        self.tabBar.itemPositioning = .centered
        self.tabBar.itemSpacing     = 100
        self.tabBar.backgroundColor = .clear
    }
    
    
    func getPathForTabBar() -> UIBezierPath {
        let frameWidth      = self.tabBar.bounds.width
        let frameHeight     = self.tabBar.bounds.height + 20
        let holeWidth       = 150
        let holeHeight      = 50
        let leftXUntilHole  = Int(frameWidth/2) - Int(holeWidth/2)
        
        let path : UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: leftXUntilHole - 10, y: 0)) // Top-Left line
        path.addCurve(to: CGPoint(x: leftXUntilHole + (holeWidth/3), y: holeHeight/2), controlPoint1: CGPoint(x: leftXUntilHole + ((holeWidth/3)/8)*6,y: 0), controlPoint2: CGPoint(x: leftXUntilHole + ((holeWidth/3)/8)*8, y: holeHeight/2)) // Left middle curve
        
        path.addCurve(to: CGPoint(x: leftXUntilHole + (2*holeWidth)/3, y: holeHeight/2), controlPoint1: CGPoint(x: leftXUntilHole + (holeWidth/3) + (holeWidth/3)/3*2/5, y: (holeHeight/2)*6/4), controlPoint2: CGPoint(x: leftXUntilHole + (holeWidth/3) + (holeWidth/3)/3*2 + (holeWidth/3)/3*3/5, y: (holeHeight/2)*6/4)) // Middle curve
        
        path.addCurve(to: CGPoint(x: leftXUntilHole + holeWidth, y: 0), controlPoint1: CGPoint(x: leftXUntilHole + (2*holeWidth)/3,y: holeHeight/2), controlPoint2: CGPoint(x: leftXUntilHole + (2*holeWidth)/3 + (holeWidth/3)*2/8, y: 0)) // Right middle curve
        path.addLine(to: CGPoint(x: frameWidth + 10, y: 0)) // Top-Right line
        path.addLine(to: CGPoint(x: frameWidth, y: frameHeight + 30)) // Right line
        path.addLine(to: CGPoint(x: 0, y: frameHeight + 30)) // Bottom line
        path.addLine(to: CGPoint(x: -10, y: 0)) // Left line
        path.close()
        return path
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        let path: UIBezierPath  = getPathForTabBar()
        let shape               = CAShapeLayer()
        shape.path              = path.cgPath
        shape.lineWidth         = 3
        shape.strokeColor       = UIColor.systemPink.cgColor
        shape.fillColor         = UIColor.systemBackground.cgColor
        self.tabBar.layer.replaceSublayer(self.tabBar.layer.sublayers![1], with: shape)
    }
}
