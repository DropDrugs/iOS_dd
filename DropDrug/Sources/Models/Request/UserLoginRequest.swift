// Copyright © 2024 RT4. All rights reserved

import Foundation

struct UserLoginRequest : Codable{
    let email : String
    let password : String
}

struct UserRegisterRequest : Codable{
    let email : String
    let password : String
    let name : String
}


