// Copyright © 2024 RT4. All rights reserved

import UIKit
import Moya
import SnapKit
import PinLayout
import KeychainSwift

class SplashVC : UIViewController {
    
    let provider = MoyaProvider<LoginService>(plugins: [ NetworkLoggerPlugin() ])
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Drop Drug"
        label.font = UIFont.roRegularFont(ofSize: 50)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.checkAuthenticationStatus()
        }
    }
    
    func setupViews() {
        view.backgroundColor = Constants.Colors.skyblue
        view.addSubview(titleLabel)
    }
    
    func navigateToMainScreen() {
        let mainVC = MainTabBarController()
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true, completion: nil)
    }
    
    func navigateToOnBoaringScreen() {
        let onboardingVC = OnboardingVC()
        onboardingVC.modalPresentationStyle = .fullScreen
        present(onboardingVC, animated: true, completion: nil)
    }
    
    func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func checkAuthenticationStatus() {
        if let accessToken = SelectLoginTypeVC.keychain.get("serverAccessToken") {
            if isTokenExpired(token: accessToken) {
                refreshAccessToken { success in
                    if success {
                        print("accessToken 재발급 성공")
                        self.navigateToMainScreen()
                    } else {
                        print("accessToken 재발급 실패")
                        self.navigateToOnBoaringScreen()
                    }
                }
            } else {
                print("Access Token 유효: \(accessToken)")
                navigateToMainScreen()
            }
        } else {
            print("토큰 없음. 로그인 화면으로 이동.")
            navigateToOnBoaringScreen()
        }
    }
    
    func isTokenExpired(token: String) -> Bool {
        let segments = token.split(separator: ".")
        guard segments.count == 3 else {
            print("Invalid JWT token format")
            return true // 만료된 것으로 간주
        }
        
        let payloadSegment = segments[1]
        guard let payloadData = Data(base64Encoded: String(payloadSegment)) else {
            print("Failed to decode payload")
            return true
        }
        
        do {
            if let payload = try JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any],
               let exp = payload["exp"] as? TimeInterval {
                let expirationDate = Date(timeIntervalSince1970: exp)
                return expirationDate < Date()
            }
        } catch {
            print("Failed to parse payload: \(error)")
        }
        return true // 만료된 것으로 간주
    }
    
}
