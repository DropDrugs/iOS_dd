// Copyright © 2024 RT4. All rights reserved

import Foundation

struct OAuthSocialLoginRequest : Codable{
    let accessToken: String
    let fcmToken : String
    let idToken : String
}

struct OAuthAppleLoginRequest : Codable {
    let fcmToken : String
    let idToken : String
    let authorizationCode : String
}
