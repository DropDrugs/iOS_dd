// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit

import CryptoKit
import AuthenticationServices
import FirebaseAuth
import KakaoSDKUser

import KeychainSwift

class SelectLoginTypeVC : UIViewController {
    
    static let keychain = KeychainSwift() // For storing tokens like GoogleAccessToken, GoogleRefreshToken, FCMToken, serverAccessToken, KakaoAccessToken, KakaoRefreshToken
    
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
    
    @objc func kakaoButtonTapped() {
        Task {
            if await kakaoAuthVM.KakaoLogin() {
                DispatchQueue.main.async {
                    UserApi.shared.me() { [weak self] (user, error) in
                        guard self != nil else { return }
                        if let error = error {
                            print(error)
                            return
                        }
                        let userName = user?.kakaoAccount?.name
                        let userEmail = user?.kakaoAccount?.email
//                        let userProfile = user?.kakaoAccount?.profile?.profileImageUrl
                                    
                        print("이름: \(userName)")
                        print("이메일: \(userEmail)")
//                        print("프로필: \(userProfile)")

//                        userInfo["providerId"] = userID
//                        userInfo["email"] = userEmail
//                        print(userInfo)
                        // TODO :하단 kakao login api 호출 함수 작성
                    }
                }
            } else {
                print("Login failed.")
            }
        }
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
        startSignInWithAppleFlow()
    }
    
    func fetchFirebaseIDToken(completion: @escaping (String?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            print("User is not logged in")
            completion(nil)
            return
        }
        
        currentUser.getIDToken { token, error in
            if let error = error {
                print("Error fetching ID token: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            completion(token)
        }
    }
}

extension SelectLoginTypeVC : ASAuthorizationControllerDelegate {
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        return String(nonce)
    }
    
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            guard let nonce = currentNonce else {
                print("Error: Nonce is missing.")
                return
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Error: Unable to fetch identity token.")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Error: Unable to serialize token string.")
                return
            }

            guard let fullName = appleIDCredential.fullName else {
                print("Unable to fetch full name")
                return
            }
            SelectLoginTypeVC.keychain.set(appleIDToken, forKey: "appleUserIDToken")
            
            if let givenName = fullName.givenName, let familyName = fullName.familyName {
                let completeName = "\(givenName) \(familyName)"
                SelectLoginTypeVC.keychain.set(completeName, forKey: "appleUserfullName")
                print("Saved fullName: \(completeName)")
            } else {
                print("No full name provided.")
            }
            
            print("idTokenString : \(idTokenString)")

            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString, rawNonce: nonce, fullName: fullName)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Error Apple sign in: \(error.localizedDescription)")
                    return
                }

                print("애플 로그인 성공")
                
                self.fetchFirebaseIDToken { idToken in
                    if let idToken = idToken {
                        print("Firebase ID Token: \(idToken)")
                    }
                    DispatchQueue.main.async {
                        let mainTabBarVC = MainTabBarController()
                        self.navigationController?.pushViewController(mainTabBarVC, animated: true)
                    }
                }
            }
            
        default:
            print("Error: Unsupported credential type.")
            break
        }

    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
    
}

extension SelectLoginTypeVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? UIWindow()
    }
}