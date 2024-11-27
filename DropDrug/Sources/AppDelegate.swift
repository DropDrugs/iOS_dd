// Copyright © 2024 RT4. All rights reserved

import Foundation
import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import AuthenticationServices

import FirebaseCore
import FirebaseAuth

import FirebaseFirestore
import FirebaseMessaging

import Moya


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let provider = MoyaProvider<LoginService>(plugins: [ NetworkLoggerPlugin() ])
    
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        if let kakaoAPIkey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_NATIVE_APP_KEY") as? String {
            KakaoSDK.initSDK(appKey: "\(kakaoAPIkey)")
        }
    
        FirebaseApp.configure()
        if FirebaseApp.app() == nil {
            print("FirebaseApp is not initialized. Configuring now...")
            FirebaseApp.configure()
        } else {
            print("FirebaseApp is initialized successfully.")
        }
        
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound] // 필요한 알림 권한을 설정
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
                
        // 파이어베이스 Meesaging 설정
        Messaging.messaging().delegate = self
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let viewController = SplashVC()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
//    private func checkAuthenticationStatus() {
//        guard let accessToken = SelectLoginTypeVC.keychain.get("serverAccessToken"),
//              let accessTokenExpiryMillis = SelectLoginTypeVC.keychain.get("accessTokenExpiresIn"),
//              let expiryMillis = Int64(accessTokenExpiryMillis),
//              let accessTokenExpiryDate = Date(milliseconds: expiryMillis) else {
//            //accessToken 존재 X
//            return
//        }
//            
//        if Date() < accessTokenExpiryDate {
//            print("AccessToken 유효. 갱신 불필요.")
//        } else {
//            print("AccessToken 만료. RefreshToken으로 갱신 시도.")
//            self.refreshAccessToken { success in
//                if success {
//                    print("refresh AccessToken successfully")
//                } else {
//                    print("Failed to refresh AccessToken")
//                }
//            }
//        }
//    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // 백그라운드에서 푸시 알림을 탭했을 때 실행
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        print("APNS token: \(deviceToken.debugDescription)")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .banner, .list])
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs 등록 및 디바이스 토큰 받기 실패:" + error.localizedDescription)
    }
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        if AuthApi.isKakaoTalkLoginUrl(url) {
//            return AuthController.handleOpenUrl(url: url)
//        }
//        return false
//    }
}

extension AppDelegate: MessagingDelegate {
    // 파이어베이스 MessagingDelegate 설정
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        print("Firebase registration token: \(String(describing: fcmToken))")
        SelectLoginTypeVC.keychain.set(fcmToken!, forKey: "FCMToken")
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
      
            } else if let token = token {
                print("----FCM registration token: \(token)")
                
            }
        }
    }
}

extension Date {
    init?(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000.0)
    }
}
