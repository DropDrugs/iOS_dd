// Copyright © 2024 RT4. All rights reserved

import Foundation
import UIKit
import NMapsMap
 
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
 
        let viewController = SignUpVC()

        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}
