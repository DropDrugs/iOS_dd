// Copyright © 2024 RT4. All rights reserved

import UIKit
import Moya
import KeychainSwift

extension SignUpVC {
    func setupSignUpDTO(_ emailString: String, _ pwString: String) -> memberSignupRequest {
        return memberSignupRequest(email: emailString, password: pwString)
    }

    
    func callSignUpAPI(_ userParameter: memberSignupRequest, completion: @escaping (Bool) -> Void) {
        provider.request(.postRegister(param: userParameter)) { result in
            switch result {
            case .success(let response):
                do {
                    _ = try response.map(IdResponse.self)
                    completion(true)
                } catch {
                    print("Failed to map data : \(error)")
                    completion(false)
                }
            case .failure(let error):
                print("Request failed: \(error.localizedDescription)")
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
                    completion(false)
                }
            case .failure(let error) :
                print("Request failed: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
}
