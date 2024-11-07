//
//  AppDelegate.swift
//  DropDrug
//
//  Created by 김도연 on 10/25/24.
//

import Foundation
import UIKit
import GoogleSignIn
import KakaoSDKCommon
//import FirebaseCoreInternal

 
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
 
    var window: UIWindow?
    
    func application(
            _ app: UIApplication,
            open url: URL,
            options: [UIApplication.OpenURLOptionsKey: Any] = [:]
        ) -> Bool {
            return GIDSignIn.sharedInstance.handle(url)
    }
 
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        KakaoSDK.initSDK(appKey: "%{KAKAO_NATIVE_APP_KEY}")
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let viewController = SplashVC()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
 
        return true
    }
 
}
