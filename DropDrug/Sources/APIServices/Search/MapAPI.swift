// Copyright © 2024 RT4. All rights reserved

import Foundation
import Moya

enum MapAPI {
    case getPlaceInfo(addrLvl1: String, addrLvl2: String, type: String)
}

extension MapAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.NetworkManager.baseURL) else {
            fatalError("fatal error - invalid url")
        }
        return url
    }
    
    var path: String {
        return "maps/division"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .getPlaceInfo(let addrLvl1, let addrLvl2, let type):
            return .requestParameters(
                parameters: [
                    "addrLvl1": addrLvl1,
                    "addrLvl2": addrLvl2,
                    "type": type
                ],
                encoding: URLEncoding.queryString
            )
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }

}
