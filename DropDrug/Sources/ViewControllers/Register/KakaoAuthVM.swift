//// Copyright © 2024 RT4. All rights reserved
//
//import Foundation
//import Combine
//import KakaoSDKAuth
//import KakaoSDKUser
//
//class KakaoAuthVM: ObservableObject {
//    
//    var subscriptions = Set<AnyCancellable>()
//    
//    @Published var isLoggedIn: Bool = false
//    @Published var errorMessage: String? // 에러 메시지를 저장하는 변수
//    
//    // 사용자 토큰 저장을 위한 변수
//    @Published private(set) var oauthToken: String? {
//        didSet {
//            isLoggedIn = oauthToken != nil
//        }
//    }
//    
//    init() {
//        print("KakaoAuthVM - init() called")
//        loadToken() // 초기화 시 저장된 토큰 로드
//    }
//    
//    // 저장된 토큰을 로드하여 자동 로그인 시도
//    private func loadToken() {
//        if let tokenString = UserDefaults.standard.string(forKey: "kakaoToken") {
//            oauthToken = tokenString
//            isLoggedIn = true
//            print("토큰 로드 성공, 자동 로그인 시도 중")
//        } else {
//            print("저장된 토큰이 없습니다.")
//        }
//    }
//    
//    // 토큰을 안전하게 저장
//    private func saveToken(_ token: String) {
//        UserDefaults.standard.set(token, forKey: "kakaoToken")
//        oauthToken = token
//    }
//    
//    // 카카오톡 앱으로 로그인 인증
//    func kakaoLoginWithApp() async -> Bool {
//        await withCheckedContinuation { continuation in
//            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
//                if let error = error {
//                    print(error)
//                    self?.errorMessage = "카카오톡으로 로그인 실패: \(error.localizedDescription)"
//                    continuation.resume(returning: false)
//                } else if let oauthToken = oauthToken {
//                    print("loginWithKakaoTalk() success.")
//                    self?.saveToken(oauthToken.accessToken) // 토큰 저장
//                    continuation.resume(returning: true)
//                }
//            }
//        }
//    }
//    
//    // 카카오 계정으로 로그인
//    func kakaoLoginWithAccount() async -> Bool {
//        await withCheckedContinuation { continuation in
//            UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
//                if let error = error {
//                    print(error)
//                    self?.errorMessage = "카카오 계정으로 로그인 실패: \(error.localizedDescription)"
//                    continuation.resume(returning: false)
//                } else if let oauthToken = oauthToken {
//                    print("loginWithKakaoAccount() success.")
//                    self?.saveToken(oauthToken.accessToken) // 토큰 저장
//                    continuation.resume(returning: true)
//                }
//            }
//        }
//    }
//    
//    @MainActor
//    func KakaoLogin() async -> Bool {
//        print("KakaoAuthVM - KakaoLogin() called")
//        
//        return await withCheckedContinuation { continuation in
//            Task {
//                let loginSuccess: Bool
//                if (UserApi.isKakaoTalkLoginAvailable()) {
//                    loginSuccess = await kakaoLoginWithApp()
//                } else {
//                    loginSuccess = await kakaoLoginWithAccount()
//                }
//                continuation.resume(returning: loginSuccess)
//            }
//        }
//    }
//    
//    @MainActor
//    func kakaoLogout() {
//        Task {
//            if await handleKakaoLogOut() {
//                clearToken() // 로그아웃 시 토큰 삭제
//                self.isLoggedIn = false
//            }
//        }
//    }
//    
//    func handleKakaoLogOut() async -> Bool {
//        await withCheckedContinuation { continuation in
//            UserApi.shared.logout { [weak self] (error) in
//                if let error = error {
//                    print(error)
//                    self?.errorMessage = "로그아웃 실패: \(error.localizedDescription)"
//                    continuation.resume(returning: false)
//                } else {
//                    print("logout() success.")
//                    continuation.resume(returning: true)
//                }
//            }
//        }
//    }
//    
//    // 저장된 토큰을 삭제
//    private func clearToken() {
//        UserDefaults.standard.removeObject(forKey: "kakaoToken")
//        oauthToken = nil
//    }
//}
