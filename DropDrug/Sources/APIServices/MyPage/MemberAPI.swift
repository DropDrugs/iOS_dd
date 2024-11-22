// Copyright © 2024 RT4. All rights reserved

import Foundation
import Moya
import KeychainSwift

enum MemberAPI {
    case fetchMemberInfo
    case purchaseCharacter(characterId: Int) // 캐릭터 구매
    case updateCharacter(characterId: Int)  // 캐릭터 변경
    case updateNickname(newNickname: String) // 닉네임 변경
    case updateNotificationSettings(disposal: Bool, noticeboard: Bool, reward: Bool) // 알림 설정 변경
}

extension MemberAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://54.180.45.153:8080")!
    }
    
    var path: String {
        switch self {
        case .fetchMemberInfo:
            return "/members"
        case .purchaseCharacter(let characterId):
            return "/members/character/\(characterId)"
        case .updateCharacter(let characterId):
            return "/members/character/\(characterId)"
        case .updateNickname(let newNickname):
            return "/members/nickname/\(newNickname)"
        case .updateNotificationSettings:
            return "/members/notification"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchMemberInfo:
            return .get
        case .purchaseCharacter:
            return .post
        case .updateCharacter, .updateNickname, .updateNotificationSettings:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .fetchMemberInfo:
            return .requestPlain
        case .purchaseCharacter:
            return .requestPlain
        case .updateCharacter:
            return .requestPlain
        case .updateNickname:
            return .requestPlain
        case .updateNotificationSettings(let disposal, let noticeboard, let reward):
            let parameters: [String: Any] = [
                "disposal": disposal,
                "noticeboard": noticeboard,
                "reward": reward
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
