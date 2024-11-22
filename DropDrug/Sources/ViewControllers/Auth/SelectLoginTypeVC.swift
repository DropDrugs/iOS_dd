// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit

import CryptoKit
import AuthenticationServices
import FirebaseAuth
import KakaoSDKUser

import KeychainSwift
import Moya

class SelectLoginTypeVC : UIViewController {
    
    let provider = MoyaProvider<LoginService>(plugins: [ NetworkLoggerPlugin() ])
    
    static let keychain = KeychainSwift() // For storing tokens like GoogleAccessToken, GoogleRefreshToken, FCMToken, serverAccessToken, KakaoAccessToken, KakaoRefreshToken, KakaoIdToken
    
    lazy var kakaoAuthVM: KakaoAuthVM = KakaoAuthVM()
    fileprivate var currentNonce: String?
    
    lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "드롭드럭에서\n올바른 의약품 폐기를 함께하고\n나와 지구를 치료해요!"
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
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = superViewWidth * 0.075
        button.addTarget(self, action: #selector(kakaoButtonTapped), for: .touchUpInside)
        return button
    }()
    //    let appleLoginButton = ASAuthorizationAppleIDButton()
    
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
        setupUI()
        setupGradientBackground()
        setupConstraints()
        
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
        let subviews = [mainLabel, kakaoLoginButton, signUpButton, loginButton]
        subviews.forEach { view.addSubview($0) }
    }
    
    private func setupConstraints() {
        mainLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(superViewHeight * 0.45)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(superViewWidth * 0.1)
        }
        kakaoLoginButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(superViewHeight * 0.76)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(superViewWidth * 0.15)
        }
        signUpButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(superViewHeight * 0.68)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(superViewWidth * 0.15)
        }
        loginButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(superViewHeight * 0.92)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        setupAppleLoginButton()
    }
    
    func setupAppleLoginButton() {
        let appleButton = ASAuthorizationAppleIDButton()
        appleButton.addTarget(self, action: #selector(handleAppleLogin), for: .touchUpInside)
        appleButton.cornerRadius =  superViewWidth * 0.075
        self.view.addSubview(appleButton)
        
        // SnapKit을 사용하는 경우 위치 설정
        appleButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(superViewHeight * 0.84)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(superViewWidth * 0.15)
        }
    }
    
    //    @objc func kakaoButtonTapped() {
    //        Task {
    //            if await kakaoAuthVM.KakaoLogin() {
    //                UserApi.shared.me() { [weak self] (user, error) in
    //                    guard let self = self else { return }
    //
    //                    if let error = error {
    //                        print("에러 발생: \(error.localizedDescription)")
    //                        return
    //                    }
    //
    //                    guard let kakaoAccount = user?.kakaoAccount else {
    //                        print("사용자 정보 없음")
    //                        return
    //                    }
    //
    //                    let userId = user?.id ?? 123
    //
    //                    print("유저: \(userId)")
    //                    let idToken = SelectLoginTypeVC.keychain.get("idToken")
    //                    // TODO: 서버에 카카오 사용자 정보 전달 및 로그인 처리
    //                    self.handleKakaoLoginSuccess()
    //                }
    //            } else {
    //                print("카카오 로그인 실패")
    //            }
    //        }
    //    }
    
    @objc func kakaoButtonTapped() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            // Kakao 로그인 실행
            self.kakaoAuthVM.KakaoLogin { success in
                if success {
                    // Kakao 사용자 정보 가져오기
                    UserApi.shared.me { (user, error) in
                        if let error = error {
                            print("에러 발생: \(error.localizedDescription)")
                            return
                        }
                        
                        guard let kakaoAccount = user?.kakaoAccount else {
                            print("사용자 정보 없음")
                            return
                        }
                        if let loginRequest = self.setupKakaoLoginDTO() {
                            self.callKakaoLoginAPI(loginRequest) { isSuccess in
                                if isSuccess {
                                    self.handleKakaoLoginSuccess()
                                } else {
                                    print("카카오 로그인 실패")
                                }
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        print("카카오 로그인 실패")
                    }
                }
            }
        }
    }
    
    private func handleKakaoLoginSuccess() {
        let mainVC = MainTabBarController()
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true, completion: nil)
    }
    
    //    @objc private func googleButtonTapped() {
    //        // Google login setup
    //        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
    //        let config = GIDConfiguration(clientID: clientID)
    //
    //        GIDSignIn.sharedInstance.signIn(withPresenting: self) {signInResult, error in
    //            guard error == nil else { return }
    //            guard let result = signInResult,
    //                  let token = result.user.idToken?.tokenString else { return }
    //
    //            let user = result.user
    //            let fullName = user.profile?.name
    //            let accesstoken = result.user.accessToken.tokenString
    //            let refreshtoken = result.user.refreshToken.tokenString
    //
    //            print(user)
    //            print(fullName as Any)
    //            print("accesstoken : \(accesstoken)")
    //            print("refreshtoken: \(refreshtoken)")
    //        }
    //
    //    }
    
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
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            
            if let identityToken = appleIDCredential.identityToken,
               let identityTokenString = String(data: identityToken, encoding: .utf8) {
                SelectLoginTypeVC.keychain.set(identityTokenString, forKey: "AppleIDToken")
                callAppleLoginAPI(param: setupAppleDTO(identityTokenString)!) { isSuccess in
                    if isSuccess {
                        self.handleKakaoLoginSuccess()
                    } else {
                        print("애플 로그인(바로 로그인) 실패")
                    }
                }
            }
        case let passwordCredential as ASPasswordCredential:
            let username = passwordCredential.user
            let password = passwordCredential.password
            guard let identityTokenString = SelectLoginTypeVC.keychain.get("AppleIDToken") else { return }
            callAppleLoginAPI(param: setupAppleDTO(identityTokenString)!) { isSuccess in
                if isSuccess {
                    self.handleKakaoLoginSuccess()
                } else {
                    print("애플 로그인 (패스워드 시도) 실패")
                }
            }
            
        default:
            break
            
            
        }
        
    }
}

extension SelectLoginTypeVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? UIWindow()
    }
}
