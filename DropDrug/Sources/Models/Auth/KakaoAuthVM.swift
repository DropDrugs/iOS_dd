// Copyright © 2024 RT4. All rights reserved

import UIKit
import Combine
import KakaoSDKAuth
import KakaoSDKUser
import KeychainSwift

class KakaoAuthVM: ObservableObject {
    
    var subscriptions = Set<AnyCancellable>()
    
    let hasKakaoTokens = SelectLoginTypeVC.keychain.get("KakaoAccessToken") != nil || SelectLoginTypeVC.keychain.get("KakaoRefreshToken") != nil || SelectLoginTypeVC.keychain.get("KakaoIdToken") != nil
    
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
//    private func saveAccessToken(_ token: String) {
//        oauthToken = token
//        SelectLoginTypeVC.keychain.set(token, forKey: "KakaoAccessToken")
//    }
//    
//    private func saveRefreshToken(_ token: String) {
//        oauthToken = token
//        SelectLoginTypeVC.keychain.set(token, forKey: "KakaoRefreshToken")
//    }
//    
//    private func saveIdToken(_ token: String?) {
//        let tokenToSave = token ?? "DefaultToken"
//        SelectLoginTypeVC.keychain.set(tokenToSave, forKey: "KakaoIdToken")
//    }
    
    private func saveTokens(accessToken: String, refreshToken: String, idToken: String?, expiredAt: Date) {
        let idTokenToSave = idToken ?? "DefaultToken"
        
        let formatter = ISO8601DateFormatter()
        let expiredAtString = formatter.string(from: expiredAt)

        SelectLoginTypeVC.keychain.set(accessToken, forKey: "KakaoAccessToken")
        SelectLoginTypeVC.keychain.set(refreshToken, forKey: "KakaoRefreshToken")
        SelectLoginTypeVC.keychain.set(idTokenToSave, forKey: "KakaoIdToken")
        SelectLoginTypeVC.keychain.set(expiredAtString, forKey: "KakaoTokenExpiredAt")

        oauthToken = accessToken
        
        // 디버깅용 로그
        print("🟢 토큰 저장 완료: AccessToken, RefreshToken, IdToken 및 ExpiredAt")
    }

    @MainActor
    func KakaoLogin(completion: @escaping (Bool) -> Void) {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                if let error = error {
                    print("1")
                    print("카카오톡 로그인 실패: \(error.localizedDescription)")
                    completion(false)
                } else if let oauthToken = oauthToken {
                    print("2")
                    self?.saveTokens(accessToken: oauthToken.accessToken, refreshToken: oauthToken.refreshToken, idToken: oauthToken.idToken, expiredAt: oauthToken.expiredAt)
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
                    print("2")
                    self?.saveTokens(accessToken: oauthToken.accessToken, refreshToken: oauthToken.refreshToken, idToken: oauthToken.idToken, expiredAt: oauthToken.expiredAt)
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
//                clearToken() // 로그아웃 시 토큰 삭제
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

//    func checkTokenValidity(completion : @escaping (Bool) -> Void) {
//        guard let token = SelectLoginTypeVC.keychain.get("KakaoAccessToken") else {
//                print("🔴 저장된 토큰이 없습니다.")
//                return
//            }
//            
//            // 현재 시간과 만료 시간 비교
//        if let expiredAtString = SelectLoginTypeVC.keychain.get("KakaoTokenExpiredAt"),
//           let expiredAt = ISO8601DateFormatter().date(from: expiredAtString),  // ISO8601 형식으로 변환
//           expiredAt > Date() {
//            print("🟢 Access Token은 유효합니다.")
////            unlinkKakaoAccount()
//            completion(true)
//        } else {
//            print("🔴 Access Token이 만료되었습니다.")
//            refreshToken()
//            completion(false)
//        }
//    }

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
    
    
//    func refreshToken() {
//        AuthApi.shared.refreshAccessToken { newToken, error in
//            if let error = error {
//                print("🔴 토큰 갱신 실패: \(error.localizedDescription)")
//                return
//            }
//            
//            guard let newToken = newToken else {
//                print("🔴 새로운 토큰이 없습니다.")
//                return
//            }
//            print("🟢 토큰 갱신 성공: \(newToken)")
//        }
//    }
//    
//    @MainActor
//    func unlinkKakaoAccount(completion: @escaping (Bool) -> Void) {
//        Task {
//            let success = await handleKakaoUnlink()
//            if success {
//                self.isLoggedIn = false
//            }
//            completion(success)
//        }
//    }
//
//    func handleKakaoUnlink() async -> Bool {
//        await withCheckedContinuation { continuation in
//            UserApi.shared.unlink { [weak self] error in
//                if let error = error {
//                    print("카카오 계정 연동 해제 실패: \(error.localizedDescription)")
//                    self?.errorMessage = "연동 해제 실패: \(error.localizedDescription)"
//                    continuation.resume(returning: false)
//                } else {
//                    print("카카오 계정 연동 해제 성공")
//                    continuation.resume(returning: true)
//                }
//            }
//        }
//    }
    
    // 저장된 토큰을 삭제
//    private func clearToken() {
//        SelectLoginTypeVC.keychain.clear()
//        oauthToken = nil
//    }
}
