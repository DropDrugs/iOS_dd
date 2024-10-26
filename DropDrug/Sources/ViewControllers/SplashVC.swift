// Copyright © 2024 RT4. All rights reserved

import UIKit
import Moya
import SnapKit
import PinLayout

class SplashVC : UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Drop Drug"
        label.font = UIFont.systemFont(ofSize: 50)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {self.navigateToOnBoaringScreen()}
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            if self.getRefreshToken() != nil {
//                        // refreshToken 이 있으면 메인 화면으로 이동
//                self.navigateToMainScreen()
//                    } else {
//                        // refreshToken 이 없으면 로그인 화면으로 이동
//                        self.navigateToOnBoaringScreen()
//                    }
//        }
//    }
    
    func setupViews() {
        view.addSubview(titleLabel)
        view.backgroundColor = UIColor(named: "skyblue")
    }
    
    func navigateToMainScreen() {

        }
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
