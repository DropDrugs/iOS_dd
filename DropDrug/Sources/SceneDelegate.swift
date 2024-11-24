//
//  SceneDelegate.swift
//  DropDrug
//
//  Created by 김도연 on 10/25/24.
//

import Foundation
import UIKit
import NMapsMap
 
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
 
        let viewController = SplashVC()
//        let viewController = CertificationSuccessVC()

        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}
