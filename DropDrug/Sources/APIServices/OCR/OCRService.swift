// Copyright © 2024 RT4. All rights reserved

import Foundation
import Moya

enum OCRService {
    case postImage(data : OCRRequest)
}

extension OCRService : TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.NetworkManager.OCRAPIURL) else {
            fatalError("fatal error - none url")
        }
        return url
    }
    
    var path: String {
        return "/general"
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Moya.Task {
        switch self {
        case .postImage(let data) :
            return .requestJSONEncodable(data)
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json",
            "X-OCR-SECRET": "\(Constants.NetworkManager.OCRSecretKey)"
        ]
    }
    
    
}
