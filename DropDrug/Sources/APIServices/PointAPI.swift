// Copyright © 2024 RT4. All rights reserved

import Foundation
import Moya
import KeychainSwift

enum PointAPI {
    case getPoint
    case postPoint
    case getPointHistory
    case getMonthlyStats
}

extension PointAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.NetworkManager.baseURL) else {
            fatalError("fatal error - invalid url")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getPoint:
            return "points"
        case .postPoint:
            return "members/notification"
        case .getPointHistory:
            return "points/history"
        case .getMonthlyStats:
            return "points/monthly"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPoint, .getPointHistory, .getMonthlyStats:
            return .get
        case .postPoint:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getPoint:
            return .requestPlain
        case .postPoint:
            return .requestPlain
        case .getPointHistory:
            return .requestPlain
        case .getMonthlyStats:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
