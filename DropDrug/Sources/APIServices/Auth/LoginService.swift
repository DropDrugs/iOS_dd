// Copyright © 2024 RT4. All rights reserved

import Foundation
import Moya

enum LoginService {
    // 자체 로그인
    case postLogin(param: UserLoginRequest)
    case postRegister(param: UserSignUpRequest)
    
    // SNS 로그인
    case postGoogleLogin(param: OAuthGoogleLoginRequest)
    
    // 기타
    case postLogOut(accessToken: String)
    case postQuit(accessToken: String)
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
        case .postGoogleLogin: return "auth/login/google"
        case .postLogOut: return "auth/logout"
        case .postQuit: return "auth/quit"
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
        case .postLogOut(let accessToken),
                .postQuit(let accessToken) :
            return .requestParameters(parameters: ["accessToken": accessToken], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
}
