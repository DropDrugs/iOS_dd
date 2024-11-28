// Copyright © 2024 RT4. All rights reserved

import Foundation
import Moya

enum LoginService {
    // 자체 로그인

    case postLogin(param: MemberLoginRequest)
    case postRegister(param: MemberSignupRequest)
    
    // SNS 로그인
    case postGoogleLogin(param: OAuthSocialLoginRequest)
    case postKakaoLogin(param: OAuthKakaoLoginRequest)
    case postAppleLogin(param: OAuthAppleLoginRequest)
    
    // 기타
    case postLogOut(accessToken: String)
    case postQuit(param : QuitRequest)
    
    //리프레시
    case refreshAccessToken(refreshToken: String)
}

extension LoginService: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.NetworkManager.baseURL) else {
            fatalError("fatal error - invalid url")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .postLogin: return "auth/login/pw"
        case .postRegister: return "auth/signup/pw"
        case .postKakaoLogin: return "auth/login/kakao"
        case .postGoogleLogin: return "auth/login/google"
        case .postAppleLogin: return "auth/login/apple"
        case .postLogOut: return "auth/logout"
        case .postQuit: return "auth/quit"
        case .refreshAccessToken: return "auth/refresh"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Moya.Task {
        switch self {
        case .postLogin(let param) :
            return .requestJSONEncodable(param)
        case .postRegister(let param) :
            return .requestJSONEncodable(param)
        case .postGoogleLogin(let param) :
            return .requestJSONEncodable(param)
        case .postKakaoLogin(let param) :
            return .requestJSONEncodable(param)
        case .postAppleLogin(let param) :
            return .requestJSONEncodable(param)
        case .postLogOut(let accessToken) :
            return .requestParameters(parameters: ["accessToken": accessToken], encoding: JSONEncoding.default)
        case .postQuit(let param) :
            return .requestJSONEncodable(param)
        case .refreshAccessToken(let refreshToken) :
            return .requestParameters(parameters: ["refreshToken": refreshToken], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
