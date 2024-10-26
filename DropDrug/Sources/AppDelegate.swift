//
//  AppDelegate.swift
//  DropDrug
//
//  Created by 김도연 on 10/25/24.
//

import Foundation
import UIKit
 
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
 
    var window: UIWindow?
 
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let viewController = TestVC()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
 
        return true
    }
 
}
