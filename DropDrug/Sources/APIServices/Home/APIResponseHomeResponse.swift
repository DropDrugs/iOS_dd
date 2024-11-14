// Copyright © 2024 RT4. All rights reserved

struct APIResponseHomeResponse : Codable {
    let isSucess : Bool
    let code : String
    let message : String
    let result : HomeResponse
}
