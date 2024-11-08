//
//  AppDelegate.swift
//  DropDrug
//
//  Created by 김도연 on 10/25/24.
//

import Foundation
import UIKit
import KakaoSDKCommon
//import GoogleSignIn
//import FirebaseCore
//import FirebaseMessaging


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        if let kakaoAPIkey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_NATIVE_APP_KEY") as? String {
            KakaoSDK.initSDK(appKey: "\(kakaoAPIkey)")
        }
        
//        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let viewController = SplashVC()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        return true
    }
    
//    func application(
//        _ app: UIApplication,
//        open url: URL,
//        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
//    ) -> Bool {
//        return GIDSignIn.sharedInstance.handle(url)
//    }
    
}
