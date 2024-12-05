// Copyright © 2024 RT4. All rights reserved

import UIKit
import Combine
import KakaoSDKAuth
import KakaoSDKUser
import KeychainSwift

class KakaoAuthVM: ObservableObject {
    
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
    }
    
    @MainActor
    func KakaoLogin(completion: @escaping (Bool) -> Void) {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                if let error = error {
                    print("카카오톡 로그인 실패: \(error.localizedDescription)")
                    completion(false)
                } else if let oauthToken = oauthToken {
                    AccountSettingsVC.hasKakaoTokens = true
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
                    AccountSettingsVC.hasKakaoTokens = true
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
    
    func unlinkKakaoAccount(completion : @escaping (Bool) -> Void) {
        UserApi.shared.unlink { error in
            if let error = error {
                print("🔴 카카오 계정 연동 해제 실패: \(error.localizedDescription)")
                completion(false)
            }
            print("🟢 카카오 계정 연동 해제 성공")
            completion(true)
        }
    }
}
