// Copyright © 2024 RT4. All rights reserved

import UIKit
import Moya

extension SignUpVC {
    func setupDTO(_ emailString: String, _ pwString: String) -> UserLoginRequest {
        return UserLoginRequest(email: emailString, password: pwString)
    }
    
    func callSignUpAPI(_ userParameter: UserLoginRequest, completion: @escaping (Bool) -> Void) {
        provider.request(.postRegister(param: userParameter)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.map(IdResponse.self)
                    completion(true)
                } catch {
                    print("Failed to map data : \(error)")
                    completion(false)
                }
            case .failure(let error):
                print("Request failed: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
}
