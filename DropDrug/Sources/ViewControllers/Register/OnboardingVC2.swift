// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit

class OnboardingVC2 : UIViewController {
    
    lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "드롭드럭에서\n올바른 의약품 폐기를 함께하고\n나와 지구를 치료해요!"
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    let googleLoginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: "f2f2f2")
        button.setTitle("구글로 시작하기", for: .normal)
        button.setTitleColor(.black.withAlphaComponent(0.7), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = superViewWidth * 0.075
        button.addTarget(OnboardingVC2.self, action: #selector(googleButtonTapped), for: .touchUpInside)
        return button
    }()
    let kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: "#FEE500")
        button.setTitle("   카카오로 시작하기", for: .normal)
        button.setTitleColor(UIColor(hex: "#191919"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = superViewWidth * 0.075
        button.addTarget(OnboardingVC2.self, action: #selector(kakaoButtonTapped), for: .touchUpInside)
        return button
    }()
    lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("E-mail로 시작하기", for: .normal)
        button.backgroundColor = Constants.Colors.gray900
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = superViewWidth * 0.075
        button.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("이미 계정이 있으신가요?", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = Constants.Colors.skyblue
        super.viewDidLoad()
        setupGradientBackground()
        setupUI()
        setupConstraints()
        
        if let image = UIImage(named: "kakao_logo")?.withRenderingMode(.alwaysOriginal) {
                    let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 24, height: 24))
                    kakaoLoginButton.setImage(resizedImage, for: .normal)
                }
        if let image = UIImage(named: "google_logo")?.withRenderingMode(.alwaysOriginal) {
                    let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 40, height: 40))
                    googleLoginButton.setImage(resizedImage, for: .normal)
                }
        func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
            let renderer = UIGraphicsImageRenderer(size: targetSize)
            return renderer.image { _ in
                image.draw(in: CGRect(origin: .zero, size: targetSize))
            }
        }
    }
        
    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()

        gradientLayer.colors = [
            (Constants.Colors.coralpink?.withAlphaComponent(0.7) ?? UIColor.systemPink.withAlphaComponent(0.7)).cgColor,
            (Constants.Colors.skyblue ?? UIColor.systemTeal).cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        let diameter: CGFloat = 500
        gradientLayer.frame = CGRect(x: (view.bounds.width - diameter) / 2,
                                     y: (view.bounds.height - diameter) / 2,
                                     width: diameter,
                                     height: diameter)
        gradientLayer.cornerRadius = diameter / 2
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
        
    private func setupUI() {
        view.addSubview(mainLabel)
        view.addSubview(googleLoginButton)
        view.addSubview(kakaoLoginButton)
        view.addSubview(signUpButton)
        view.addSubview(loginButton)
    }
    
    private func setupConstraints() {
        mainLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(superViewHeight * 0.45)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(superViewWidth * 0.1)
        }
        googleLoginButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(superViewHeight * 0.68)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(superViewWidth * 0.15)
        }
        kakaoLoginButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(superViewHeight * 0.76)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(superViewWidth * 0.15)
        }
        signUpButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(superViewHeight * 0.84)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(superViewWidth * 0.15)
        }
        loginButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(superViewHeight * 0.92)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    @objc func kakaoButtonTapped() {
        Task {
//            if await kakaoAuthVM.KakaoLogin() {
//                DispatchQueue.main.async {
//                    UserApi.shared.me() { [weak self] (user, error) in
//                        guard let self = self else { return }
//                        if let error = error {
//                            print(error)
//                            return
//                        }
//                        let userID = user?.id ?? nil
//                        let userEmail = user?.kakaoAccount?.email ?? ""
//
//                        userInfo["providerId"] = userID
//                        userInfo["email"] = userEmail
//                        print(userInfo)
//                        // TODO :하단 kakao login api 호출 함수 작성
//                    }
//                }
//            } else {
//                print("Login failed.")
//            }
        }
    }
    
    @objc func googleButtonTapped() {
        Task {
            
        }
    }
    @objc func startTapped() {
        let SignUpVC = SignUpVC()
        SignUpVC.modalPresentationStyle = .fullScreen
        present(SignUpVC, animated: true, completion: nil)
    }
    
    @objc func loginButtonTapped() {
        let loginVC = LoginVC()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }
}
