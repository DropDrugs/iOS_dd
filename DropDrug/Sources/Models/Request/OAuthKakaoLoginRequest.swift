// Copyright © 2024 RT4. All rights reserved

import Foundation

struct OAuthKakaoLoginRequest : Codable{
    let accessToken: String
    let fcmToken : String
    let idToken : String
}
