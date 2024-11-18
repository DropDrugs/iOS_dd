// Copyright © 2024 RT4. All rights reserved

import Foundation
import Moya
import KeychainSwift

enum MemberAPI {
    case fetchMemberInfo
}

extension MemberAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://54.180.45.153:8080")!
    }
    
    var path: String {
        switch self {
        case .fetchMemberInfo:
            return "/members"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchMemberInfo:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .fetchMemberInfo:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        let keychain = KeychainSwift()
        if let accessToken = keychain.get("serverAccessToken") {
            return [
                "Authorization": "Bearer \(accessToken)",
                "Accept": "*/*"
            ]
        }
        return ["Accept": "*/*"]
    }
}
