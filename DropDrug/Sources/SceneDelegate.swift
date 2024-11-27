// Copyright © 2024 RT4. All rights reserved

import Foundation
import UIKit
import NMapsMap
import KakaoSDKAuth
 
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
 
        let viewController = SplashVC()

        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
            if let url = URLContexts.first?.url {
                // 카카오톡 인증 URL 처리
                if AuthApi.isKakaoTalkLoginUrl(url) {
                    _ = AuthController.handleOpenUrl(url: url)

                    // 로그인 성공 시 메인 화면으로 이동
                    if let accessToken = SelectLoginTypeVC.keychain.get("ServerAccessToken") {
                        print("카카오 로그인 성공! Access Token: \(accessToken)")
                        navigateToMainScreen()
                    } else {
                        print("카카오 로그인 실패: 토큰 없음")
                    }
                }
            }
        }

    private func navigateToMainScreen() {
        let mainVC = MainTabBarController()
        mainVC.modalPresentationStyle = .fullScreen
        window?.rootViewController?.present(mainVC, animated: true)
    }
}
