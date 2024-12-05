// Copyright © 2024 RT4. All rights reserved

import UIKit
import Moya
import SwiftyToaster

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
                    Toaster.shared.makeToast("\(response.statusCode) : 데이터를 불러오는데 실패했습니다.")
                    completion(false, nil)
                }
            case .failure(let error) :
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
                completion(false, nil)
            }
        }
    }
    
}

extension SelectDrugTypeVC {
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
                    Toaster.shared.makeToast("\(response.statusCode) : 데이터를 불러오는데 실패했습니다.")
                    completion(false, nil)
                }
            case .failure(let error) :
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
                completion(false, nil)
            }
        }
    }
}
