// Copyright © 2024 RT4. All rights reserved

import UIKit

class MainTabBarController: UITabBarController {
    
    private let HomeVC = UINavigationController(rootViewController: ViewController())
    private let SearchVC = UINavigationController(rootViewController: ViewController())
    private let LocationVC = UINavigationController(rootViewController: ViewController())
    private let InfoVC = UINavigationController(rootViewController: ViewController())
    private let MyVC = UINavigationController(rootViewController: ViewController())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTabBar()
    }
    
    private func setupTabBar() {
        self.tabBar.tintColor = UIColor(hue: 0.5361, saturation: 0.71, brightness: 0.96, alpha: 1.0)
        //self.tabBar.unselectedItemTintColor = UIColor(hex: "#A2A2A2")

        HomeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "Home")?.withRenderingMode(.alwaysOriginal), tag: 0)
        
        SearchVC.tabBarItem = UITabBarItem(title: "검색", image: UIImage(named: "Search")?.withRenderingMode(.alwaysOriginal), tag: 1)
        
        LocationVC.tabBarItem = UITabBarItem(title: "탐색", image: UIImage(named: "Location")?.withRenderingMode(.alwaysOriginal), tag: 2)
        
        InfoVC.tabBarItem = UITabBarItem(title: "정보", image: UIImage(named: "Info")?.withRenderingMode(.alwaysOriginal), tag: 3)
        
        MyVC.tabBarItem = UITabBarItem(title: "마이", image: UIImage(named: "My")?.withRenderingMode(.alwaysOriginal), tag: 4)
        
        viewControllers = [HomeVC, SearchVC, LocationVC, InfoVC, MyVC]
    }
}
