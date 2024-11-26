// Copyright © 2024 RT4. All rights reserved

import UIKit
import Moya
import SnapKit
import PinLayout
import KeychainSwift
import SwiftyToaster

class SplashVC : UIViewController {
    
    let tokenPlugin = BearerTokenPlugin()
    
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
            self.tokenPlugin.checkAuthenticationStatus { token in
                if let token = token {
                    self.navigateToMainScreen()
                } else {
//                    Toaster.shared.makeToast("자동로그인에 실패했습니다.")
                    self.navigateToOnBoaringScreen()
                }
            }
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
