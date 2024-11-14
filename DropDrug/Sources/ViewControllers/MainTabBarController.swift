// Copyright © 2024 RT4. All rights reserved

import UIKit

class MainTabBarController: UITabBarController {
    
    private let HomeVC = UINavigationController(rootViewController: HomeViewController())
    private let SearchVC = UINavigationController(rootViewController: TestVC())
    private let LocationVC = UINavigationController(rootViewController: TestVC())
    private let InfoVC = UINavigationController(rootViewController: InfoMainViewController())
    private let MyVC = UINavigationController(rootViewController: TestVC())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        
        self.tabBar.backgroundColor = .white
        
        UITabBar.clearShadow()
        tabBar.layer.applyShadow(color: .gray, alpha: 0.3, x: 0, y: 0, blur: 15)
        
        self.tabBar.tintColor = UIColor(named: "skyblue")
        self.tabBar.unselectedItemTintColor = UIColor(named: "Gray500")
        HomeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "Home")?.withRenderingMode(.alwaysTemplate), tag: 0)
        
        SearchVC.tabBarItem = UITabBarItem(title: "등록", image: UIImage(named: "Register")?.withRenderingMode(.alwaysTemplate), tag: 1)
        
        LocationVC.tabBarItem = UITabBarItem(title: "탐색", image: UIImage(named: "Location")?.withRenderingMode(.alwaysTemplate), tag: 2)
        
        InfoVC.tabBarItem = UITabBarItem(title: "정보", image: UIImage(named: "Info")?.withRenderingMode(.alwaysTemplate), tag: 3)
        
        MyVC.tabBarItem = UITabBarItem(title: "마이", image: UIImage(named: "My")?.withRenderingMode(.alwaysTemplate), tag: 4)
        
        
        viewControllers = [HomeVC, SearchVC, LocationVC, InfoVC, MyVC]
    }
}
