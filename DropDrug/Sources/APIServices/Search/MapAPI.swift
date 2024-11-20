// Copyright © 2024 RT4. All rights reserved

import Foundation
import Moya

enum MapAPI {
    case getPlaceInfo
}

extension MapAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.NetworkManager.baseURL) else {
            fatalError("fatal error - invalid url")
        }
        return url
    }
    
    var path: String {
        return "maps/seoul"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }

}
