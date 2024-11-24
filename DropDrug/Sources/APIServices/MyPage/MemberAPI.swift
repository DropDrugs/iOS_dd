// Copyright © 2024 RT4. All rights reserved

import Foundation
import Moya
import KeychainSwift

enum MemberAPI {
    case fetchMemberInfo
    case purchaseCharacter(characterId: Int) // 캐릭터 구매
    case checkDuplicateEmail(email: String) //이메일 중복 확인
    case updateCharacter(characterId: Int)  // 캐릭터 변경
    case updateNickname(newNickname: String) // 닉네임 변경
    case updateNotificationSettings(param: NotificationSetting) // 알림 설정 변경
}

extension MemberAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.NetworkManager.baseURL) else {
            fatalError("fatal error - invalid url")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .fetchMemberInfo:
            return "members"
        case .purchaseCharacter(let characterId):
            return "members/character/\(characterId)"
        case .updateCharacter(let characterId):
            return "members/character/\(characterId)"
        case .updateNickname(let newNickname):
            return "members/nickname/\(newNickname)"
        case .checkDuplicateEmail(let email):
            return "members/email/\(email)"
        case .updateNotificationSettings:
            return "members/notification"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchMemberInfo, .checkDuplicateEmail:
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
        case .checkDuplicateEmail:
            return .requestPlain
        case .purchaseCharacter:
            return .requestPlain
        case .updateCharacter:
            return .requestPlain
        case .updateNickname:
            return .requestPlain
        case .updateNotificationSettings(let param) :
            return .requestJSONEncodable(param)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
