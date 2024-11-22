// Copyright © 2024 RT4. All rights reserved

import Foundation
import Combine
import KakaoSDKAuth
import KakaoSDKUser
import KeychainSwift

class KakaoAuthVM: ObservableObject {
    
    static let keychain = KeychainSwift()
    
    var subscriptions = Set<AnyCancellable>()
    
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String? // 에러 메시지를 저장하는 변수
    
    // 사용자 토큰 저장을 위한 변수
    @Published private(set) var oauthToken: String? {
        didSet {
            isLoggedIn = oauthToken != nil
        }
    }
    
    init() {
        print("KakaoAuthVM - init() called")
        loadToken() // 초기화 시 저장된 토큰 로드
    }
    
    // 저장된 토큰을 로드하여 자동 로그인 시도
    private func loadToken() {
        if let tokenString = SelectLoginTypeVC.keychain.get("KakaoAccessToken") {
            oauthToken = tokenString
            isLoggedIn = true
            print("토큰 로드 성공, 자동 로그인 시도 중")
        } else {
            print("저장된 토큰이 없습니다.")
        }
    }
    
    // 토큰을 안전하게 저장
    private func saveAccessToken(_ token: String) {
        oauthToken = token
        SelectLoginTypeVC.keychain.set(token, forKey: "KakaoAccessToken")
    }
    
    private func saveRefreshToken(_ token: String) {
        oauthToken = token
        SelectLoginTypeVC.keychain.set(token, forKey: "KakaoRefreshToken")
    }
    
    private func saveIdToken(_ token: String?) {
        let tokenToSave = token ?? "DefaultToken"
        SelectLoginTypeVC.keychain.set(tokenToSave, forKey: "KakaoIdToken")
    }

    @MainActor
    func KakaoLogin(completion: @escaping (Bool) -> Void) {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                if let error = error {
                    print("카카오톡 로그인 실패: \(error.localizedDescription)")
                    completion(false)
                } else if let oauthToken = oauthToken {
                    self?.saveAccessToken(oauthToken.accessToken)
                    self?.saveRefreshToken(oauthToken.refreshToken)
                    self?.saveIdToken(oauthToken.idToken)
                    print("카카오톡 로그인 성공")
                    completion(true)
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
                if let error = error {
                    print("카카오 계정 로그인 실패: \(error.localizedDescription)")
                    completion(false)
                } else if let oauthToken = oauthToken {
                    self?.saveAccessToken(oauthToken.accessToken)
                    self?.saveRefreshToken(oauthToken.refreshToken)
                    self?.saveIdToken(oauthToken.idToken)
                    print("카카오 계정 로그인 성공")
                    completion(true)
                }
            }
        }
    }
    
    @MainActor
    func kakaoLogout() {
        Task {
            if await handleKakaoLogOut() {
                clearToken() // 로그아웃 시 토큰 삭제
                self.isLoggedIn = false
            }
        }
    }
    
    func handleKakaoLogOut() async -> Bool {
        await withCheckedContinuation { continuation in
            UserApi.shared.logout { [weak self] (error) in
                if let error = error {
                    print(error)
                    self?.errorMessage = "로그아웃 실패: \(error.localizedDescription)"
                    continuation.resume(returning: false)
                } else {
                    print("logout() success.")
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    // 저장된 토큰을 삭제
    private func clearToken() {
        //TODO: keychain kakotoken clear
        UserDefaults.standard.removeObject(forKey: "kakaoToken")
        oauthToken = nil
    }
}
