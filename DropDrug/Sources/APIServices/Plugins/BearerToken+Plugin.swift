// Copyright © 2024 RT4. All rights reserved

import Foundation
import Moya
import SwiftyToaster

final class BearerTokenPlugin: PluginType {
    private var accessToken: String? {
        return SelectLoginTypeVC.keychain.get("serverAccessToken")
    }

    func checkAuthenticationStatus(completion: @escaping (String?) -> Void) {
        guard let accessToken = SelectLoginTypeVC.keychain.get("serverAccessToken"),
              let accessTokenExpiryMillis = SelectLoginTypeVC.keychain.get("accessTokenExpiresIn"),
              let expiryMillis = Int64(accessTokenExpiryMillis),
              let accessTokenExpiryDate = Date(milliseconds: expiryMillis) else {
            print("AccessToken이 존재하지 않음.")
            refreshAccessToken(completion: completion)
            return
        }
        
        if Date() < accessTokenExpiryDate {
            print("AccessToken 유효. 갱신 불필요.")
            completion(accessToken)
        } else {
            print("AccessToken 만료. RefreshToken으로 갱신 시도.")
            refreshAccessToken(completion: completion)
        }
    }
    
    private func refreshAccessToken(completion: @escaping (String?) -> Void) {
        guard let refreshToken = SelectLoginTypeVC.keychain.get("serverRefreshToken") else {
            print("RefreshToken이 존재하지 않음.")
            Toaster.shared.makeToast("다시 로그인 해 주세요")
            completion(nil)
            return
        }
        
        let provider = MoyaProvider<LoginService>(plugins: [NetworkLoggerPlugin()])
        provider.request(.refreshAccessToken(refreshToken: refreshToken)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.map(RefreshTokenDto.self)
                    SelectLoginTypeVC.keychain.set(data.accessToken, forKey: "serverAccessToken")
                    SelectLoginTypeVC.keychain.set(String(data.accessTokenExpiresIn), forKey: "accessTokenExpiresIn")
                    SelectLoginTypeVC.keychain.delete("serverRefreshToken")
                    print("AccessToken 갱신 성공.")
                    completion(data.accessToken)
                } catch {
                    Toaster.shared.makeToast("데이터를 불러오는 데 실패했습니다.")
                    completion(nil)
                }
            case .failure(let error):
                Toaster.shared.makeToast("\(error.localizedDescription)")
                if let response = error.response {
                    print("Response Body: \(String(data: response.data, encoding: .utf8) ?? "")")
                }
                completion(nil)
            }
        }
    }
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        
        let semaphore = DispatchSemaphore(value: 0) // 동기적 작업을 위해 사용
        var tokenToAdd: String?

        checkAuthenticationStatus { token in
            tokenToAdd = token
            semaphore.signal()
        }
        
        semaphore.wait()
        
        if let token = tokenToAdd {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
}


//// Copyright © 2024 RT4. All rights reserved
//
//import Foundation
//import Moya
//
//final class BearerTokenPlugin: PluginType {
//    private var accessToken: String? {
//        return SelectLoginTypeVC.keychain.get("serverAccessToken")
//    }
//
//    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
//        var request = request
//
//        // 만약 accessToken이 있다면 Authorization 헤더에 추가합니다.
//        if let token = accessToken {
//            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        }
//
//        return request
//    }
//}
