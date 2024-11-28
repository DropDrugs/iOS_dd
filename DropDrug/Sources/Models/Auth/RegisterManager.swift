// Copyright © 2024 RT4. All rights reserved

import UIKit
import Moya
import KeychainSwift
import SwiftyToaster

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
                    let _ = try response.map(IdResponse.self)
                    completion(true)
                } catch {
                    Toaster.shared.makeToast("데이터를 불러오는데 실패했습니다.")
                    completion(false)
                }
            case .failure(let error) :
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
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
                    SelectLoginTypeVC.keychain.set(String(data.accessTokenExpiresIn), forKey: "accessTokenExpiresIn")
                    completion(true)
                } catch {
                    Toaster.shared.makeToast("\(response.statusCode) : 데이터를 불러오는데 실패했습니다.")
                }
            case .failure(let error) :
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
                completion(false)
            }
        }
    }
}

extension SelectLoginTypeVC {
    func setupKakaoLoginDTO(_ emailString: String, _ nameString: String) -> OAuthKakaoLoginRequest? {
        guard let fcmToken = SelectLoginTypeVC.keychain.get("FCMToken") else { return nil }
        return OAuthKakaoLoginRequest(email: emailString, fcmToken: fcmToken, name: nameString)
    }

    func callKakaoLoginAPI(_ userParameter: OAuthKakaoLoginRequest, completion: @escaping (Bool) -> Void) {
        provider.request(.postKakaoLogin(param: userParameter)) { result in
            switch result {
            case .success(let response):
                do {
                    print("로그인 성공: \(response)")
                    let data = try response.map(TokenDto.self)
                    SelectLoginTypeVC.keychain.set(data.refreshToken, forKey: "serverRefreshToken")
                    SelectLoginTypeVC.keychain.set(data.accessToken, forKey: "serverAccessToken")
                    completion(true)
                } catch {
                    Toaster.shared.makeToast("\(response.statusCode) : 데이터를 불러오는데 실패했습니다.")
                    completion(false)
                }
            case .failure(let error) :
                if let response = error.response {
                    print("로그인 실패: \(error.localizedDescription)")
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
                completion(false)
            }
        }
    }
    
    func setupAppleDTO(_ idToken: String, _ authorizationCode : String) -> OAuthAppleLoginRequest? {
        guard let fcmToken = SelectLoginTypeVC.keychain.get("FCMToken") else { return nil }
        return OAuthAppleLoginRequest(fcmToken: fcmToken, idToken: idToken, authorizationCode: authorizationCode)
    }
    
    func callAppleLoginAPI(param : OAuthAppleLoginRequest, completion: @escaping (Bool, Bool) -> Void) {
        provider.request(.postAppleLogin(param: param)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.map(TokenDto.self)
                    SelectLoginTypeVC.keychain.set(data.refreshToken, forKey: "serverRefreshToken")
                    SelectLoginTypeVC.keychain.set(data.accessToken, forKey: "serverAccessToken")
                    completion(true, data.isNewUser ?? false)
                } catch {
                    Toaster.shared.makeToast("\(response.statusCode) : 데이터를 불러오는데 실패했습니다.")
                    completion(false, false)
                }
            case .failure(let error) :
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                    print("Response Body: \(String(data: response.data, encoding: .utf8) ?? "")")
                }
                completion(false, false)
            }
        }
    }
}
