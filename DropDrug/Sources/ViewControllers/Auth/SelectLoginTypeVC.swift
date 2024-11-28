// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit

import CryptoKit
import AuthenticationServices
import FirebaseAuth
import KakaoSDKUser

import KeychainSwift
import Moya
import SwiftyToaster

class SelectLoginTypeVC : UIViewController {
    
    let provider = MoyaProvider<LoginService>(plugins: [ NetworkLoggerPlugin() ])
    
    static let keychain = KeychainSwift() // For storing tokens like GoogleAccessToken, GoogleRefreshToken, FCMToken, serverAccessToken, serverRefreshToken, KakaoAccessToken, KakaoRefreshToken, KakaoIdToken, accessTokenExpiresIn
    
    lazy var kakaoAuthVM: KakaoAuthVM = KakaoAuthVM()
    var userName: String = ""
    var userEmail: String = ""
    
    fileprivate var currentNonce: String?
    
    lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "드롭드락에서\n올바른 의약품 폐기를 함께하고\n나와 지구를 치료해요!"
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    let kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: "#FEE500")
        button.setTitle("   카카오로 시작하기", for: .normal)
        button.setTitleColor(UIColor(hex: "#191919"), for: .normal)
        button.titleLabel?.font = UIFont.ptdSemiBoldFont(ofSize: 22)
        button.layer.cornerRadius = superViewWidth * 0.075
        button.addTarget(self, action: #selector(kakaoButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("E-mail로 시작하기", for: .normal)
        button.backgroundColor = Constants.Colors.gray900
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.ptdSemiBoldFont(ofSize: 22)
        button.layer.cornerRadius = superViewWidth * 0.075
        button.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        return button
    }()
    
    let appleButton = ASAuthorizationAppleIDButton()
    
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
        setupUI()
        setupGradientBackground()
        setupConstraints()
        
        appleButton.addTarget(self, action: #selector(handleAppleLogin), for: .touchUpInside)
        appleButton.cornerRadius =  superViewWidth * 0.075
        
        if let image = UIImage(named: "kakao_logo")?.withRenderingMode(.alwaysOriginal) {
            let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 24, height: 24))
            kakaoLoginButton.setImage(resizedImage, for: .normal)
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
        let subviews = [mainLabel, kakaoLoginButton, signUpButton, appleButton, loginButton]
        subviews.forEach { view.addSubview($0) }
    }
    
    private func setupConstraints() {
        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(superViewHeight * 0.35)
            make.centerX.equalToSuperview()
        }
        signUpButton.snp.makeConstraints { make in
            make.bottom.equalTo(kakaoLoginButton.snp.top).inset(-superViewHeight * 0.01)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(superViewWidth * 0.15)
        }
        kakaoLoginButton.snp.makeConstraints { make in
            make.bottom.equalTo(appleButton.snp.top).inset(-superViewHeight * 0.01)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(superViewWidth * 0.15)
        }
        appleButton.snp.makeConstraints { make in
            make.bottom.equalTo(loginButton.snp.top).inset(-superViewHeight * 0.01)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(superViewWidth * 0.15)
        }
        loginButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(superViewHeight * 0.92)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }

//    @objc func kakaoButtonTapped() {
//        
//        let hasKakaoTokens = SelectLoginTypeVC.keychain.get("KakaoAccessToken") != nil || SelectLoginTypeVC.keychain.get("KakaoRefreshToken") != nil || SelectLoginTypeVC.keychain.get("KakaoIdToken") != nil
//        
//        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//            guard let self = self else { return }
//            
//            // Kakao 로그인 실행
//            if !hasKakaoTokens { // 저장된 카카오 토큰이 없으면 회원가입
//                print("3")
//                self.kakaoAuthVM.KakaoLogin { success in
//                    if success {
//                        print("4")
//                        UserApi.shared.me { (user, error) in
//                            if let error = error {
//                                print("에러 발생: \(error.localizedDescription)")
//                                return
//                            }
//                            print("5")
//                            let userName = user?.kakaoAccount?.profile?.nickname! ?? ""
//                            let userEmail = user?.kakaoAccount?.email! ?? ""
//                            print("\(userName)")
//                            print("\(userEmail)")
//                            SelectLoginTypeVC.keychain.set(userName, forKey: "userName")
//                            SelectLoginTypeVC.keychain.set(userEmail, forKey: "userEmail")
//                            print("6")
//                            self.sendKakaoSignUpRequest()
//                        }
//                        
//                    } else {
//                        print("7")
//                    }
//                }
//            } else {
//                self.kakaoAuthVM.KakaoLogin { success in
//                    if success {
//                        self.goToHomeVC()
//                        print("8")
//                        Toaster.shared.makeToast("카카오 로그인 성공")
//                    } else {
//                        print("9")
//                        Toaster.shared.makeToast("카카오 로그인 실패")
//                    }
//                }
//            }
//        }
//    }
    
//    @objc func kakaoButtonTapped() {
//        // 카카오 토큰 존재 여부 확인
//        let hasKakaoTokens = SelectLoginTypeVC.keychain.get("KakaoAccessToken") != nil ||
//                             SelectLoginTypeVC.keychain.get("KakaoRefreshToken") != nil ||
//                             SelectLoginTypeVC.keychain.get("KakaoIdToken") != nil
//
//        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//            guard let self = self else { return }
//
//            if hasKakaoTokens {
//                // 기존 가입된 유저인 경우 로그인 처리
//                self.kakaoAuthVM.KakaoLogin { success in
//                    if success {
//                        DispatchQueue.main.async {
//                            print("기존 유저 로그인 성공")
//                            self.goToHomeVC()
//                            Toaster.shared.makeToast("카카오 로그인 성공")
//                        }
//                    } else {
//                        print("기존 유저 로그인 실패")
//                        Toaster.shared.makeToast("카카오 로그인 실패")
//                    }
//                }
//            } else {
//                // 신규 유저인 경우 회원가입 처리
//                self.kakaoAuthVM.KakaoLogin { success in
//                    if success {
//                        print("신규 유저 로그인 성공")
//                        UserApi.shared.me { (user, error) in
//                            if let error = error {
//                                print("에러 발생: \(error.localizedDescription)")
//                                DispatchQueue.main.async {
//                                    Toaster.shared.makeToast("사용자 정보 가져오기 실패")
//                                }
//                                return
//                            }
//
//                            // 사용자 정보 가져오기
//                            let userName = user?.kakaoAccount?.profile?.nickname ?? ""
//                            let userEmail = user?.kakaoAccount?.email ?? ""
//                            print("사용자 이름: \(userName), 이메일: \(userEmail)")
//
//                            // 키체인에 사용자 정보 저장
//                            SelectLoginTypeVC.keychain.set(userName, forKey: "userName")
//                            SelectLoginTypeVC.keychain.set(userEmail, forKey: "userEmail")
//
//                            // 회원가입 요청
//                            self.sendKakaoSignUpRequest()
//                        }
//                    } else {
//                        print("신규 유저 로그인 실패")
//                        Toaster.shared.makeToast("카카오 회원가입 실패")
//                    }
//                }
//            }
//        }
//    }
    @objc func kakaoButtonTapped() {
        // 카카오 토큰 존재 여부 확인
        let hasKakaoTokens = SelectLoginTypeVC.keychain.get("KakaoAccessToken") != nil ||
                             SelectLoginTypeVC.keychain.get("KakaoRefreshToken") != nil ||
                             SelectLoginTypeVC.keychain.get("KakaoIdToken") != nil

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            // 신규 유저인 경우 회원가입 처리
            self.kakaoAuthVM.KakaoLogin { success in
                if success {
                    print("신규 유저 로그인 성공")
                    UserApi.shared.me { (user, error) in
                        if let error = error {
                            print("에러 발생: \(error.localizedDescription)")
                            DispatchQueue.main.async {
                                Toaster.shared.makeToast("사용자 정보 가져오기 실패")
                            }
                            return
                        }
                        
                        // 사용자 정보 가져오기
                        self.userName = user?.kakaoAccount?.profile?.nickname ?? ""
                        self.userEmail = user?.kakaoAccount?.email ?? ""
                        print("사용자 이름: \(self.userName), 이메일: \(self.userEmail)")
                        
                        // 회원가입 요청
                        self.sendKakaoSignUpRequest()
                    }
                } else {
                    print("신규 유저 로그인 실패")
                    Toaster.shared.makeToast("카카오 회원가입 실패")
                }
            }
        }
    }
    
    
    
    private func sendKakaoSignUpRequest() {
        // 회원가입 요청 생성
        guard let kakaoSignUpRequest = self.setupKakaoLoginDTO(self.userEmail, self.userName) else {
            print("카카오 회원가입 Dto 생성 실패")
            return
        }

        // API 호출
        self.callKakaoLoginAPI(kakaoSignUpRequest) { isSuccess in
            if isSuccess {
                self.goToHomeVC()
                Toaster.shared.makeToast("카카오 회원가입 성공")
            } else {
                Toaster.shared.makeToast("카카오 회원가입 실패")
                print("회원 가입 실패")
            }
        }
    }

//    @objc func signUpButtonTapped() {
//        if isValid {
//            let signUpRequest = setupSignUpDTO(emailField.textField.text!, passwordField.textField.text!, name: usernameField.textField.text!)
//            callSignUpAPI(signUpRequest) { isSuccess in
//                if isSuccess {
//                    self.loginButtonTapped()
//                } else {
//                    print("회원 가입 실패")
//                }
//            }
//        }
//    }
//    
    
    func handleKakaoLoginSuccess() {
        DispatchQueue.main.async {
            let mainVC = MainTabBarController()
            mainVC.modalPresentationStyle = .fullScreen
            self.present(mainVC, animated: true, completion: nil)
        }
    }
    
    func goToHomeVC() {
        let mainVC = MainTabBarController()
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true, completion: nil)
    }
    
    private func handleAppleLoginSuccess() {
        let mainVC = EnterNickNameVC()
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true, completion: nil)
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
    
    @objc func handleAppleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
}

extension SelectLoginTypeVC : ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential :
            let userIdentifier = appleIDCredential.user
            var authorizationCode : String?
            
            if let authCode = appleIDCredential.authorizationCode,
               let authCodeString = String(data: authCode, encoding: .utf8) {
                authorizationCode = authCodeString
            } else {
                authorizationCode = nil
                print("authcode 발급 실패")
            }
            
            if let identityToken = appleIDCredential.identityToken {
                if let identityTokenString = String(data: identityToken, encoding: .utf8) {
                    SelectLoginTypeVC.keychain.set(identityTokenString, forKey: "AppleIDToken")
                    print("idToken: \(identityTokenString)")
                    guard let authCode = authorizationCode else {
                        print("authCode 발급 실패")
                        return }
                    guard let data = setupAppleDTO(identityTokenString, authCode) else { return }
                    callAppleLoginAPI(param: data) { isSuccess, isNewUser in
                        if isSuccess {
                            if isNewUser {
                                self.handleAppleLoginSuccess()
                            } else {
                                self.goToHomeVC()
                            }
                        } else {
                            print("애플 로그인 실패")
                        }
                    }
                }
            } else {
                if let idTokenString = SelectLoginTypeVC.keychain.get("AppleIDToken") {
                    guard let authCode = authorizationCode else {
                        print("authCode 발급 실패")
                        return
                    }
                    guard let data = setupAppleDTO(idTokenString, authCode) else { return }
                    callAppleLoginAPI(param: data) { isSuccess, isNewUser in
                        if isSuccess {
                            if isNewUser {
                                self.handleAppleLoginSuccess()
                            } else {
                                self.goToHomeVC()
                            }
                        } else {
                            print("애플 로그인 실패")
                        }
                    }
                }
            }
            
        default :
            break
        }
//            
//            if let identityToken = appleIDCredential.identityToken,
//               let identityTokenString = String(data: identityToken, encoding: .utf8),
//               let emailString = email {
//                SelectLoginTypeVC.keychain.set(emailString, forKey: "AppleIDEmail")
//                SelectLoginTypeVC.keychain.set(formattedName, forKey: "AppleIDName")
//                callAppleLoginAPI(param: setupAppleDTO(identityTokenString, formattedName, emailString, authorizationCode)!) { isSuccess in
//                    if isSuccess {
//                        self.handleKakaoLoginSuccess()
//                    } else {
//                        print("애플 로그인(바로 로그인) 실패")
//                    }
//                }
//            } else {
//                guard let identityTokenString = SelectLoginTypeVC.keychain.get("AppleIDToken"),
//                      let emailString = SelectLoginTypeVC.keychain.get("AppleIDEmail"),
//                      let nameString = SelectLoginTypeVC.keychain.get("AppleIDName") else { return }
//
//                
//            }
        
    }
}

extension SelectLoginTypeVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? UIWindow()
    }
}
