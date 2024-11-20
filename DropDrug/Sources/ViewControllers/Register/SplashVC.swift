// Copyright © 2024 RT4. All rights reserved

import UIKit
import Moya
import SnapKit
import PinLayout
import KeychainSwift

class SplashVC : UIViewController {
    
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
//            self.navigateToMainScreen()
        }
    }
    
    private func checkAuthenticationStatus() {
        let keychain = KeychainSwift()

        if let accessToken = keychain.get("serverAccessToken"),
           let refreshToken = keychain.get("serverRefreshToken") {
            print("Access Token 존재: \(accessToken)")
            navigateToMainScreen()
//        } else if let refreshToken = keychain.get("serverRefreshToken") {
//            print("Access Token 없음. Refresh Token 존재.")
//            refreshAccessToken(refreshToken: refreshToken) { success in
//                if success {
//                    self?.navigateToMainScreen()
//                } else {
//                    print("Refresh Token 갱신 실패.")
//                    self?.navigateToOnBoaringScreen()
//                }
//            }
        } else {
            print("토큰 없음. 로그인 화면으로 이동.")
            navigateToOnBoaringScreen()
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
    
}
