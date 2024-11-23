// Copyright © 2024 RT4. All rights reserved

import Foundation
import Moya
import KeychainSwift

enum DrugAPI {
    case getDrug
    case postDrug(param: drugSaveRequest)
    case deleteDrug(param: drugDeleteRequest)
}

extension DrugAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.NetworkManager.baseURL) else {
            fatalError("fatal error - invalid url")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getDrug, .postDrug, .deleteDrug:
            return "drugs"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getDrug:
            return .get
        case .postDrug:
            return .post
        case .deleteDrug:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .getDrug:
            return .requestPlain
        case .postDrug(let param):
            return .requestJSONEncodable(param)
        case .deleteDrug(let param):
            return .requestJSONEncodable(param)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
