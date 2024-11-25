// Copyright © 2024 RT4. All rights reserved

import Foundation
import Moya

enum BoardService {
    case getBoard
    case postBoard(param : AddBoardRequest)
    case patchBoard(param : BoardUpdateRequest)
    case deleteBoard(id : Int)
}

extension BoardService: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.NetworkManager.baseURL) else {
            fatalError("fatal error - invalid url")
        }
        return url
    }
    
    var path: String {
        return "board"
    }
    
    var method: Moya.Method {
        switch self {
        case .getBoard : return .get
        case .postBoard : return .post
        case .patchBoard : return .patch
        case .deleteBoard : return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .getBoard :
            return .requestPlain
        case .postBoard(let param) :
            return .requestJSONEncodable(param)
        case .patchBoard(let param) :
            return .requestJSONEncodable(param)
        case .deleteBoard(let id) :
            return .requestParameters(parameters: ["id" : id], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
