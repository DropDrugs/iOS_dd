// Copyright © 2024 RT4. All rights reserved

import Foundation

// 구글 로그인 response
struct TokenDto : Codable {
    let accessToken : String
    let accessTokenExpiresIn : Int
    let grantType : String
    let isNewUser : Bool?
    let refreshToken : String
    let refreshTokenExpiresIn : Int
    let userId : Int
}


