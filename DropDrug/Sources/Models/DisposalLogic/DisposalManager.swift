// Copyright © 2024 RT4. All rights reserved

import UIKit
import Moya

extension CertificationSuccessVC {
    // post api 보내기
    func setupData(point : Int, type : String, location : String) -> AddPointRequest {
        return AddPointRequest(point: point, type: type, location: location)
    }
    
    func postSuccessPoint(data : AddPointRequest, completion: @escaping (Bool, Bool?) -> Void) {
        provider.request(.postPoint(param: data)) { result in
            switch result {
            case .success(let response) :
                do {
                    let responseData = try response.map(BadgeEarnedResponse.self)
                    completion(true, responseData.getBadge)
                } catch {
                    print("Failed to decode response: \(error)")
                    completion(false, nil)
                }
            case .failure(let error) :
                print("Error: \(error.localizedDescription)")
                if let response = error.response {
                    print("Response Body: \(String(data: response.data, encoding: .utf8) ?? "")")
                }
                completion(false, nil)
            }
        }
    }
    
}
