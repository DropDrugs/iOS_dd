// Copyright © 2024 RT4. All rights reserved

import Foundation
import Moya

final class BearerTokenPlugin: PluginType {
    private var accessToken: String? {
        return SelectLoginTypeVC.keychain.get("serverRefreshToken")
    }

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request

        // 만약 accessToken이 있다면 Authorization 헤더에 추가합니다.
        if let token = accessToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return request
    }
}
