// Copyright © 2024 RT4. All rights reserved

import UIKit
import Moya
import KeychainSwift

extension SplashVC {
    func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        guard let refreshToken = SelectLoginTypeVC.keychain.get("refreshToken") else {
            print("refreshToken not found")
            completion(false)
            return
        }
        provider.request(.refreshAccessToken(token: refreshToken)) { result in
            switch result {
            case .success(let response):
                print(response)
                do {
                    let data = try response.map(TokenDto.self)
                    SelectLoginTypeVC.keychain.set(data.refreshToken, forKey: "serverRefreshToken")
                    SelectLoginTypeVC.keychain.set(data.accessToken, forKey: "serverAccessToken")
                    completion(true)
                } catch {
                    print("Failed to map data : \(error)")
                    completion(false)
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                if let response = error.response {
                    print("Response Body: \(String(data: response.data, encoding: .utf8) ?? "")")
                }
                completion(false)
            }
        }
    }
}

extension SignUpVC {
    func setupSignUpDTO(_ emailString: String, _ pwString: String, name : String) -> MemberSignupRequest {
        return MemberSignupRequest(email: emailString, name: name, password: pwString)
    }

    func callSignUpAPI(_ userParameter: MemberSignupRequest, completion: @escaping (Bool) -> Void) {
        provider.request(.postRegister(param: userParameter)) { result in
            switch result {
            case .success(let response):
                print(response)
                do {
                    let data = try response.map(IdResponse.self)
                    completion(true)
                } catch {
                    print("Failed to map data : \(error)")
                    completion(false)
                }
            case .failure(let error) :
                print("Error: \(error.localizedDescription)")
                if let response = error.response {
                    print("Response Body: \(String(data: response.data, encoding: .utf8) ?? "")")
                }
                completion(false)
            }
        }
    }
}

extension LoginVC {
    func setupLoginDTO(_ emailString: String, _ pwString: String) -> MemberLoginRequest? {
        guard let fcmToken = SelectLoginTypeVC.keychain.get("FCMToken") else { return nil }
        return MemberLoginRequest(email: emailString, password: pwString, fcmToken: fcmToken)
    }
    
    func callLoginAPI(_ userParameter: MemberLoginRequest, completion: @escaping (Bool) -> Void) {
        provider.request(.postLogin(param: userParameter)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.map(TokenDto.self)
                    SelectLoginTypeVC.keychain.set(data.refreshToken, forKey: "serverRefreshToken")
                    SelectLoginTypeVC.keychain.set(data.accessToken, forKey: "serverAccessToken")
                    completion(true)
                } catch {
                    print("Failed to map data : \(error)")
                     
                }
            case .failure(let error) :
                print("Error: \(error.localizedDescription)")
                if let response = error.response {
                    print("Response Body: \(String(data: response.data, encoding: .utf8) ?? "")")
                }
                completion(false)
            }
        }
    }
}

extension SelectLoginTypeVC {
    func setupKakaoLoginDTO() -> OAuthSocialLoginRequest? {
        guard let fcmToken = SelectLoginTypeVC.keychain.get("FCMToken") else { return nil }
        guard let accessToken = SelectLoginTypeVC.keychain.get("KakaoAccessToken") else { return nil }
        guard let idToken = SelectLoginTypeVC.keychain.get("KakaoIdToken") else { return nil }
        return OAuthSocialLoginRequest(accessToken: accessToken, fcmToken: fcmToken, idToken: idToken)
    }
    
    func callKakaoLoginAPI(_ userParameter: OAuthSocialLoginRequest, completion: @escaping (Bool) -> Void) {
        provider.request(.postKakaoLogin(param: userParameter)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.map(TokenDto.self)
                    SelectLoginTypeVC.keychain.set(data.refreshToken, forKey: "serverRefreshToken")
                    SelectLoginTypeVC.keychain.set(data.accessToken, forKey: "serverAccessToken")
                    completion(true)
                } catch {
                    print("Failed to map data : \(error)")
                    completion(false)
                }
            case .failure(let error) :
                print("Request failed: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    func setupAppleDTO(_ idToken: String, _ name: String, _ email: String) -> OAuthAppleLoginRequest? {
        guard let fcmToken = SelectLoginTypeVC.keychain.get("FCMToken") else { return nil }
        return OAuthAppleLoginRequest(fcmToken: fcmToken, name: name, email: email)
    }
    func callAppleLoginAPI(param : OAuthAppleLoginRequest, completion: @escaping (Bool) -> Void) {
        provider.request(.postAppleLogin(param: param)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.map(TokenDto.self)
                    SelectLoginTypeVC.keychain.set(data.refreshToken, forKey: "serverRefreshToken")
                    SelectLoginTypeVC.keychain.set(data.accessToken, forKey: "serverAccessToken")
                    completion(true)
                } catch {
                    print("Failed to map data : \(error)")
                    completion(false)
                }
            case .failure(let error) :
                print("Request failed: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
}
