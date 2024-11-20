// Copyright © 2024 RT4. All rights reserved

import Foundation

struct memberSignupRequest : Codable{
    let email : String
    let password : String
}

struct MemberLoginRequest : Codable{
    let email : String
    let password : String
    let fcmToken : String
}
